module Analysis
  module AnnotationJsonifier
    class AnnotationSaver

      def initialize(parsedAnnotations, currentUser)
        @annotationsDeleted = parsedAnnotations.annotationsDeleted
        @annotationsNew = parsedAnnotations.annotationsNew
        @localizationsDeleted = parsedAnnotations.localizationsDeleted
        @localizationsNew = parsedAnnotations.localizationsNew
        @currentUser = currentUser
      end

      def save
        totalCreated = 0
        totalDeleted = 0

        # delete annotation by setting active to false
        @annotationsDeleted.each do |annotation|
          anno = Kheer::Annotation.where(annotation).first
          if anno != nil
            anno.update(active: false)
            totalDeleted += 1
          end
        end

        # create new annotation if doesn't exist
        @annotationsNew.each do |annotation|
          annotation.merge!({
            sct: Kheer::AnnotationSourceTypes.user,
            sci: @currentUser.id
          })
          Kheer::Annotation.create(annotation)
          totalCreated += 1
        end

        # for deleted localizations
        @localizationsDeleted.each do |annoLoc|
          loc = annoToLoc(annoLoc)
          if loc != nil
            loc.update(is_annotation: true)
          end
        end

        # for localizations converted to annotations
        @localizationsNew.each do |annoLoc|
          loc = annoToLoc(annoLoc)
          if loc != nil
            annoLoc.merge!({
              sct: Kheer::AnnotationSourceTypes.chiaModel,
              sci: loc.id
            })
            Kheer::Annotation.create(annoLoc)
            totalCreated += 1
            loc.update(is_annotation: true)
          end
        end

        return {created: totalCreated, deleted: totalDeleted}
      end

      def annoToLoc(annoLoc)
        loc = Kheer::Localization
            .where(ci: annoLoc[:ci])
            .where(cl: annoLoc[:cl])
            .where(fn: annoLoc[:fn])
            .where(di: annoLoc[:di])
            .where(x: annoLoc[:x0])
            .where(y: annoLoc[:y0])
            .where(w: (annoLoc[:x2] - annoLoc[:x0]))
            .where(h: (annoLoc[:y2] - annoLoc[:y0]))
            .first
        loc
      end

    end
  end
end
