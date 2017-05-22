module Bl
  class PullRequest < Command
    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/git/repositories"
      super
    end

    desc 'count ID', 'count pull requests'
    def count(id)
      res = request(:get, "#{@url}/#{id}/pullRequests/count")
      puts res.body.count
    end

    desc 'list ID', 'list pull requests'
    def list(id)
      res = request(:get, "#{@url}/#{id}/pullRequests")
      print_response(res, :pull_request)
    end
  end
end
