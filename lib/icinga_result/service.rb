module IcingaResult
  # Represents an Icinga2 service object
  class Service
    attr_accessor :name, :interval, :description, :groups

    DEFAULT_OPTONS = { interval: 3600, description: '', groups: [] }.freeze

    def initialize(name, options = DEFAULT_OPTONS)
      @name = name
      @interval = options[:interval] || DEFAULT_OPTONS[:interval]
      @description = options[:description] || DEFAULT_OPTONS[:description]
      @groups = options[:groups] || DEFAULT_OPTONS[:groups]
    end

    def timeout
      3 * @interval + 120
    end

    def data
      {
        'templates' => ['generic-service'],
        'attrs' => {
          'check_command' => 'passive',
          'enable_active_checks' => true,
          'check_interval' => timeout,
          'vars.description' => @description,
          'groups' => @groups
        }
      }
    end
  end
end