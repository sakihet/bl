module Bl
  class GitRepo < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/git/repositories"
      super
    end

    desc 'list', 'list git repositories'
    def list
      res = request(:get, @url)
      print_response(res, :gitrepo)
    end

    desc 'show ID', 'show a git repository'
    def show(id)
      res = request(:get, "#{@url}/#{id}")
      print_response(res, :gitrepo)
    end
  end
end
