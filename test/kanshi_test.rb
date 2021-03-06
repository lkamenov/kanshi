require "./test/test_helper"

describe Kanshi do
  before do
    @databases = { "test" => ENV["TEST_DATABASE_URL"] }
    @logger = MockLogger.new
    @kanshi = Kanshi.new(:databases => @databases, :logger => @logger)
    @kanshi.report # initialize data
  end

  it "logs db stats" do
    @kanshi.report
    @logger.data.map { |data| data.first[:at] }.sort.must_equal [:blks_hit, :blks_read,
      :blks_total, :locks_waiting, :numbackends, :size, :total_open_xact_time,
      :tup_deleted, :tup_fetched, :tup_inserted, :tup_returned, :tup_updated,
      :xact_commit, :xact_idle, :xact_rollback, :xact_waiting]
  end

  describe "Scrolls integration" do
    it "just uses Scrolls when available" do
      Scrolls = true
      Kanshi.new(:databases => @databases)
    end

    it "raises otherwise" do
      Object.send(:remove_const, :Scrolls) if defined?(Scrolls)
      lambda do
        Kanshi.new(:databases => @databases)
      end.must_raise(ArgumentError)
    end
  end
end
