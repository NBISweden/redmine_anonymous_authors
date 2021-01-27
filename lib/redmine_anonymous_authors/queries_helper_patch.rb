module RedmineAnonymousAuthors
  module QueriesHelperPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method :column_value_without_anonymous, :column_value
        alias_method :column_value, :column_value_with_anonymous
      end
    end

    module InstanceMethods
      def column_value_with_anonymous(column, issue, value)
        if value.class.name == 'AnonymousUser'
          link_to_user value
        else
          column_value_without_anonymous(column, issue, value)
        end
      end
    end
  end
end

