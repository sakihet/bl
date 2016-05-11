module Bl
  class Recent < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'issues COUNT', 'list recent issues'
    def issues(count=nil)
      client.get('users/myself/recentlyViewedIssues', count: count).body.each do |i|
        puts [i.issue.issueKey, i.issue.summary].join("\t")
      end
    end
  end
end
