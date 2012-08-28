module RedmineAnonymousAuthors
  module AnonymousUserPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :name, :anonymous
        alias_method_chain :mail, :anonymous
        alias_method_chain :active?, :anonymous
      end
    end

    module InstanceMethods
      def name_with_anonymous(*args)
        return I18n.t(:label_user_anonymous) unless @name
        mail.present? && !User.current.anonymous? ? @name + " <#{mail}>" : @name
      end
      def name=(name)
        @name = name && name.split(" <").first
      end
      def mail_with_anonymous
        self[:mail] unless self[:mail].blank?
      end
      def active_with_anonymous?
        true
      end
    end
  end
end

