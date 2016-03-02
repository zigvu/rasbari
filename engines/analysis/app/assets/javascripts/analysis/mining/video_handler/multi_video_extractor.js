var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.VideoHandler = Mining.VideoHandler || {};

/*
  This class handles extracting frames from multiple videos.
*/

Mining.VideoHandler.MultiVideoExtractor = function(renderCTX) {
  var self = this;

  // ----------------------------------------------
  // Load/unload videos and construct objects
  // {clip_id: {vfe:, playback_frame_rate:, previous_clip_id:, next_clip_id: }}
  this.videoFrameObjects = {};

  this.loadClipsPromise = function(clipDetailsMap){
    var loadPromises = [];
    var prevClipId;

    _.each(clipDetailsMap.sortedClipIds, function(clipId){
      var clip = clipDetailsMap.clipMap[clipId];

      if (prevClipId !== undefined){
        self.videoFrameObjects[prevClipId].next_clip_id = clipId;
      }

      var videoFrameExtractor = new Mining.VideoHandler.VideoFrameExtractor(renderCTX);
      var videoLoadPromise = videoFrameExtractor.loadVideoPromise(clip.clip_url);
      self.videoFrameObjects[clipId] = {
        vfe: videoFrameExtractor,
        playback_frame_rate: clip.playback_frame_rate,
        previous_clip_id: prevClipId
      };
      prevClipId = clipId;

      // push promises
      loadPromises.push(videoLoadPromise);
    });
    self.videoFrameObjects[prevClipId].next_clip_id = undefined;
    firstClipId = clipDetailsMap.sortedClipIds[0];
    currentClipId = clipDetailsMap.sortedClipIds[0];

    // return a promise that consolidates all load promises
    return Q.all(loadPromises);
  };

  // unload old videos
  this.unloadClips = function(){
    self.videoFrameObjects = {};
  };
  // ----------------------------------------------


  // ----------------------------------------------
  // playback of frames
  var firstClipId, currentClipId, currentClipTime = 0;
  var videoPaused = false;
  var currentPlayState = 'playing'; // 'seeking', 'ended', 'paused'

  this.pauseVideo = function(){
    var vfo = self.videoFrameObjects[currentClipId];
    if(vfo.vfe.isPlaying()){
      currentPlayState = 'seeking';
      vfo.vfe.pausePromise()
        .then(function(){ currentPlayState = 'paused'; })
        .catch(function (errorReason) { self.err(errorReason); });
    }
  };

  this.playVideo = function(){
    var vfo = self.videoFrameObjects[currentClipId];
    if(!vfo.vfe.isPlaying()){
      if(currentPlayState === 'ended'){
        // restart from begining
        currentPlayState = 'seeking';
        self.setClipPromise(firstClipId, 0)
          .then(function(){ return self.videoFrameObjects[currentClipId].vfe.playPromise(); })
          .then(function(){ currentPlayState = 'playing'; })
          .catch(function (errorReason) { self.err(errorReason); });
      } else {
        currentPlayState = 'seeking';
        vfo.vfe.playPromise()
          .then(function(){ currentPlayState = 'playing'; })
          .catch(function (errorReason) { self.err(errorReason); });
      }
    }
  };

  this.isVideoPlaying = function(){ return currentPlayState === 'playing'; };

  this.paintFrame = function(){
    self.seekToNextClipIfNeeded();

    var vfo = self.videoFrameObjects[currentClipId];
    currentClipTime = vfo.vfe.paintFrame();
    return self.getCurrentState();
  };

  this.getCurrentState = function(){
    var vfo = self.videoFrameObjects[currentClipId];
    var clipFN = Math.round(currentClipTime * vfo.playback_frame_rate);

    return {
      play_state: currentPlayState,
      clip_id: currentClipId,
      clip_fn: clipFN
    };
  };

  this.seekToNextClipIfNeeded = function(){
    // only if in playing state
    if(currentPlayState === 'playing'){
      var vfo = self.videoFrameObjects[currentClipId];
      // if current video has ended
      if(vfo.vfe.hasEnded()){
        var nextClipId = vfo.next_clip_id;
        // if there are no more videos, we are done playing
        if(nextClipId === undefined){ currentPlayState = 'ended'; return; }
        // else, we can go to next video
        currentPlayState = 'seeking';
        self.setClipPromise(nextClipId, 0)
          .then(function(){ return self.videoFrameObjects[currentClipId].vfe.playPromise(); })
          .then(function(){ currentPlayState = 'playing'; })
          .catch(function (errorReason) { self.err(errorReason); });
      }
    }
  };

  this.setClipPromise = function(clipId, clipFN){
    var vfo = self.videoFrameObjects[clipId];
    var clipTime = clipFN / vfo.playback_frame_rate;
    var sfp = vfo.vfe.seekFramePromise(clipTime)
      .then(function(ct){
        currentClipId = clipId;
        currentClipTime = ct;
        return vfo.vfe.playbackRatePromise(playbackSpeed);
      });

    return sfp;
  };

  this.seekToClipIdClipFN = function(clipId, clipFN){
    var vfo = self.videoFrameObjects[currentClipId];
    var clipTime = clipFN / vfo.playback_frame_rate;
    if(clipTime < 0){ clipTime = 0; }

    currentPlayState = 'seeking';
    if(clipId != currentClipId){
      if(vfo.vfe.isPlaying()){
        vfo.vfe.pausePromise()
          .then(function(){ return self.setClipPromise(clipId, clipFN); })
          .then(function(){ currentPlayState = 'paused'; })
          .catch(function (errorReason) { self.err(errorReason); });
      } else {
        self.setClipPromise(clipId, clipFN)
          .then(function(){ currentPlayState = 'paused'; })
          .catch(function (errorReason) { self.err(errorReason); });
      }
    } else {
      // if within the same clip
      if(vfo.vfe.isPlaying()){
        vfo.vfe.pausePromise()
          .then(function(){ return vfo.vfe.seekFramePromise(clipTime); })
          .then(function(ct){ currentClipTime = ct; currentPlayState = 'paused'; })
          .catch(function (errorReason) { self.err(errorReason); });
      } else {
        vfo.vfe.seekFramePromise(clipTime)
          .then(function(ct){ currentClipTime = ct; currentPlayState = 'paused'; })
          .catch(function (errorReason) { self.err(errorReason); });
      }
    }
  };

  // ----------------------------------------------
  // playback rate settings
  var playbackSpeed = 1.0;
  var playbackRatesArr = [0.25,0.33,0.5,0.67, 1.0, 1.5,2.0,3.0,4.0];
  var playbackRatesArrIdx = 4, playbackRatesArrIdx_normal = 4;

  this.setPlaybackNormalPromise = function(){
    playbackRatesArrIdx = playbackRatesArrIdx_normal;
    return self.setPlaybackPromise(playbackRatesArrIdx);
  };

  this.reducePlaybackRatePromise = function(){
    playbackRatesArrIdx--;
    if(playbackRatesArrIdx < 0){ playbackRatesArrIdx = 0; }
    return self.setPlaybackPromise(playbackRatesArrIdx);
  };

  this.increasePlaybackRatePromise = function(){
    playbackRatesArrIdx++;
    if(playbackRatesArrIdx >= playbackRatesArr.length){
      playbackRatesArrIdx = playbackRatesArr.length - 1;
    }
    return self.setPlaybackPromise(playbackRatesArrIdx);
  };

  this.setPlaybackPromise = function(newPlaybackRatesArrIdx){
    var speedChangeDefer = Q.defer();

    var newPlaybackSpeed = playbackRatesArr[newPlaybackRatesArrIdx];
    // note - sometimes, needs consecutive calls to have
    // normal playback speed - so no protection with checking
    // current speed
    var vfe = self.videoFrameObjects[currentClipId].vfe;
    vfe.playbackRatePromise(newPlaybackSpeed)
      .then(function(pbr){
        playbackSpeed = pbr;
        speedChangeDefer.resolve(playbackSpeed);
      })
      .catch(function (errorReason) { self.err(errorReason); });
    return speedChangeDefer.promise;
  };

  // shorthand for error printing
  this.err = function(errorReason){
    displayJavascriptError('Mining.VideoHandler.MultiVideoExtractor -> ' + errorReason);
  };

};
