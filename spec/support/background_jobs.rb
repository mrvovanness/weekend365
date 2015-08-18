module BackgroundJobs
  def run_background_job
    inline = Resque.inline
    Resque.inline = true
    yield
    Resque.inline = inline
  end
end
