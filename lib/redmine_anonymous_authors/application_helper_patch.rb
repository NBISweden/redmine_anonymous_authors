module RedmineAnonymousAuthors
  module ApplicationHelperPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :link_to_user, :anonymous
      end
    end

    module InstanceMethods
      def link_to_user_with_anonymous(user, options={})
        if user.is_a?(User) && user.anonymous?
          User.current.anonymous? || user.mail.blank? ? h(user.name) : link_to_mail(user.mail, user.name)
        else
          link_to_user_without_anonymous(user, options)
        end
      end
    end
  end
end