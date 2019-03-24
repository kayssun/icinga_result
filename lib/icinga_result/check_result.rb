module IcingaResult
  # Contains the result of a check
  class CheckResult
    attr_accessor :status, :message, :performance_data

    def initialize(status, message, performance_data = '')
      @status = status
      @message = message
      @performance_data = performance_data
    end

    def data
      data = {
        'exit_status': @status,
        'plugin_output': @message
      }
      data['performance_data'] = @performance_data if @performance_data && !@performance_data.empty?
      data
    end
  end
end
