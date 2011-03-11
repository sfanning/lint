module Lint
  require 'lint/engine' if defined?(Rails)
  
  module Helper
    def stylin name
      Rails.logger.warn "LintModule::Stylin for #{@template.template.to_yaml}"  
    end

    def scriptin name
      Rails.logger.warn "LintModule::Scriptin for #{@template.template.to_yaml}"
    end

    def include_lint_styles
      @stylesheets.present? ? stylesheet_link_tag(@stylesheets) : ''
    end

    def include_lint_scripts
      @javascripts.present? ? javascript_include_tag(@javascripts) : ''
    end
  end
    
  module Controller
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods) 
    end

    module ClassMethods
      before_filter :load_associated_files
    end

    module InstanceMethods
      def initialize
        super
        
        Rails.logger.warn ' ***** In ActionController:initialize!! '
        @stylesheets ||= [] 
        @javascripts ||= []    
      end

      def load_associated_files
        model_name = controller_name.singularize()
        [model_name, controller_name, action_name + '_' + model_name].each { |name|
          @stylesheets.push(name).uniq!   if FileTest.exist? "#{Rails.public_path}/stylesheets/#{name}.css"
          @javascripts.push(name).uniq!   if FileTest.exist? "#{Rails.public_path}/javascripts/#{name}.js"    
        }
      end
    end
  end
end