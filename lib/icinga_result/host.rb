module IcingaResult
  # Represents the current host (client)
  class Host
    DESCRIPTION_FILE = '/etc/description'.freeze

    def name
      @name ||= `hostname -f`.strip
    end

    def description
      @description ||= read_description
    end

    def read_description
      return '' unless File.exist?(DESCRIPTION_FILE)

      File.read(DESCRIPTION_FILE)
    end

    def data
      {
        'templates': ['generic-host'],
        'attrs': {
          'check_command': 'passive',
          'enable_active_checks': true,
          'vars.description' => description
        }
      }
    end
  end
end
