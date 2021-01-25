module RedmineAnonymousAuthors
  module MailerPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method :issue_add, :issue_add_with_anonymous
        alias_method :issue_edit, :issue_edit_with_anonymous
        if Redmine::VERSION::MAJOR >= 2
          alias_method :mail, :mail_with_anonymous
        else
          alias_method :create_mail, :create_mail_with_anonymous
        end
      end
    end

    module InstanceMethods
      def issue_add_with_anonymous(issue, to_users, cc_users)
        mail = issue_add_without_anonymous(issue, to_users, cc_users)
        redmine_headers 'Issue-Author' => issue.author.anonymous? ? issue.author.mail : issue.author.login
        mail
      end
      def issue_edit_with_anonymous(journal, to_users, cc_users)
        issue = journal.journalized
        mail = issue_edit_without_anonymous(journal, to_users, cc_users)
        redmine_headers 'Issue-Author' => issue.author.anonymous? ? issue.author_mail : issue.author.login
        mail
      end
      def mail_with_anonymous(headers={}, &block)
        m = mail_without_anonymous(headers, &block)
        if @issue && @issue.author.anonymous? && Setting.plugin_redmine_anonymous_authors[:no_self_notified] == '0'
           m.bcc = m.bcc.append(@issue.author_mail)
        end
        if @author && @author.anonymous? && Setting.plugin_redmine_anonymous_authors[:no_self_notified] == '1'
          headers[:to].delete(@author.mail) if headers[:to].is_a?(Array)
          headers[:cc].delete(@author.mail) if headers[:cc].is_a?(Array)
        end
        m
      end
      def create_mail_with_anonymous
        if @author && @author.anonymous? && Setting.plugin_redmine_anonymous_authors[:no_self_notified] == '1'
          if recipients
            recipients((recipients.is_a?(Array) ? recipients : [recipients]) - [@author.mail])
          end
          if cc
            cc((cc.is_a?(Array) ? cc : [cc]) - [@author.mail])
          end
        end
        create_mail_without_anonymous
      end
    end
  end
end
