module Analysis
  module AnnotationJsonifier
    class AnnotationSaver

      def initialize(parsedAnnotations, currentUser)
        @annotationsDeleted = parsedAnnotations.annotationsDeleted
        @annotationsNew = parsedAnnotations.annotationsNew
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

        return {created: totalCreated, deleted: totalDeleted}
      end

    end
  end
end
