module RedmineAnonymousAuthors
  module MailerPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :issue_add, :anonymous
        alias_method_chain :issue_edit, :anonymous
      end
    end

    module InstanceMethods
      def issue_add_with_anonymous(issue)
        mail = issue_add_without_anonymous(issue)
        redmine_headers 'Issue-Author' => issue.author.anonymous? ? issue.author.mail : issue.author.login
        mail
      end
      def issue_edit_with_anonymous(journal)
        mail = issue_edit_without_anonymous(journal)
        issue = journal.journalized
        redmine_headers 'Issue-Author' => issue.author.anonymous? ? issue.author.mail : issue.author.login
        mail
      end
    end
  end
end
