module RedmineAnonymousAuthors
  module AnonymousUserPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method :name, :name_with_anonymous
        alias_method :mail, :mail_with_anonymous
        alias_method :mail=, :mail_with_anonymous=
        alias_method :active?, :active_with_anonymous?
        attr_writer :name
      end
    end

    module InstanceMethods
      def name_with_anonymous(*args)
        @name.presence || I18n.t(:label_user_anonymous)
      end
      def mail_with_anonymous
        User.instance_method(:mail).bind(self).call
      end
      def mail_with_anonymous=(*args)
        User.instance_method(:mail=).bind(self).call(*args)
      end
      def active_with_anonymous?
        true
      end
      def instantiate_email_address_with_anonymous
         User.instance_method(:instantiate_email_address).bind(self).call
      end
    end
  end
end

