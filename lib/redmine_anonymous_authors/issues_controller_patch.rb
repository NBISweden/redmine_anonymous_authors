module RedmineAnonymousAuthors
  module IssuesControllerPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_filter :recognize_anonymous, :only => [:create, :update]
        before_filter :set_default_anonymous_author, :only => [:edit, :new, :show]
      end
    end

    module InstanceMethods
      def set_default_anonymous_author
        if User.current.anonymous?
          @issue.author_name, @issue.author_mail = cookies[:author_name], cookies[:author_mail]
        end
        true
      end

      def recognize_anonymous
        if params[:issue] && User.current.anonymous?
          User.current.name, User.current.mail = params[:issue][:author_name], params[:issue][:author_mail]
          cookies[:author_name], cookies[:author_mail] = User.current.name, User.current.mail
          @issue.author = User.current if params[:action] == 'create'
        end
        true
      end
    end
  end
end