module Architect4r #:nodoc:
  module Core #:nodoc:
    
    # Architect4r can be configured by creating a config/architect4r file 
    # and provide environment specific data.
    #
    # Thanks to the sunspot-rails gem team, as this class is heavily inspired by their work!
    #
    #   development:
    #     host: localhost
    #     port: 7474
    #     log_level: DEBUG
    #   test:
    #     host: localhost
    #     port: 7474
    #     log_level: OFF
    #   production:
    #     host: localhost
    #     port: 8080
    #     path: /my_neo_instance
    #     log_level: WARNING
    #
    class Configuration
      
      def initialize(options = {})
        options ||= {}
        @environment = options.delete(:environment).to_s if options.has_key?(:environment)
        self.custom_configuration = options.delete(:config) if options.has_key?(:config)
      end
      
      def environment
        @environment ||= 'development'
      end
      
      def host
        unless defined?(@hostname)
          @hostname   = neo4j_url.host if neo4j_url
          @hostname ||= custom_configuration_from_key('host')
          @hostname ||= default_hostname
        end
        @hostname
      end
      
      def port
        unless defined?(@port)
          @port   = neo4j_url.port if neo4j_url
          @port ||= custom_configuration_from_key('port')
          @port ||= default_port
          @port   = @port.to_i
        end
        @port
      end
      
      def path
        unless defined?(@path)
          @path   = neo4j_url.path if neo4j_url
          @path ||= custom_configuration_from_key('path')
          @path ||= default_path
        end
        @path
      end
      
      def log_level
        @log_level ||= (custom_configuration_from_key('log_level') || default_log_level)
      end
      
      def log_file
        @log_file ||= (custom_configuration_from_key('log_file') || default_log_file_location )
      end
      
      
      private
      
      def default_log_file_location
        File.join(Dir.pwd, 'log', "architect4r.#{self.environment}.log")
      end
      
      def custom_configuration_from_key( *keys )
        keys.inject(custom_configuration) do |hash, key|
          hash[key] if hash
        end
      end
      
      def custom_configuration=(input)
        @custom_configuration = if input.is_a?(Hash)
          input.stringify_keys
        elsif input.is_a?(String)
          begin
            if File.exist?(input)
              File.open(input) do |file|
                YAML.load(file)[self.environment]
              end
            else
              {}
            end
          end
        else
          {}
        end
      end
      
      def custom_configuration
        @custom_configuration ||=
          begin
            path = File.join(Dir.pwd, 'config', 'architect4r.yml')
            if File.exist?(path)
              File.open(path) do |file|
                YAML.load(file)[self.environment]
              end
            else
              {}
            end
          end
      end
    
    protected
      
      # Allow the user to configure the server by providing an environment variable 
      # with a valid url to the neo4j rest endpoint.
      def neo4j_url
        URI.parse(ENV['NEO4J_URL']) if ENV['NEO4J_URL']
      end
      
      def default_hostname
        'localhost'
      end
      
      def default_port
        { 'test'        => 7475,
          'development' => 7474,
          'production'  => 7474
        }[self.environment]  || 7474
      end
      
      def default_path
        ''
      end
      
      def default_log_level
        { 'test'        => 'OFF',
          'development' => 'INFO',
          'production'  => 'WARNING'
        }[self.environment]  || 'INFO'
      end
      
    end
  end
end