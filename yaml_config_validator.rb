class BaseValidator
  def initialize(config)
    @config = config
  end

  def check_config_has_keys(keys, config)
    unless config
      puts 'config variable does not exist'
      return false
    end
    keys.each do |key|
      unless config.key?(key)
        puts "key: #{key} does not exist in config"
        return false
      end
    end
    true
  end

  def is_string?(var)
    return true if var.respond_to?(:to_str)
    puts "#{var} does not respond to to_str"
    false
  end

  def array_contains_var?(array, var)
    return true if array.include?(var)
    puts "#{var} is not in #{array}"
    false
  end

  def is_int?(var)
    return true if var.respond_to?(:to_int)
    puts "#{var} does not respond to to_int"
    false
  end

    def is_bool?(var)
    return true if [true, false].include? var
    puts "#{var} does not evaluate to true or false"
    false
  end

  def path_exists?(path)
    path = Pathname.new(path)
    return true if path.exist?
    puts "Path #{path} does not exist"
    false
  end
end

class VagrantboxValidator < BaseValidator
  def validate
    return false unless check_config_has_keys(%w(name basebox memory cores), @config)
    return false unless is_string?(@config['name'])
    allowedbases = ['ubuntu/trusty64', 'ubuntu/xenial64']
    return false unless array_contains_var?(allowedbases, @config['basebox'])
    return false unless is_int?(@config['memory'])
    return false unless is_int?(@config['cores'])
    true
  end
end

class DatabaseValidator < BaseValidator
  def validate
    return false unless check_config_has_keys(%w(type name owner password tuning), @config)
    allowedtypes = %w(pgsql mysqli)
    return false unless array_contains_var?(allowedtypes, @config['type'])
    return false unless is_string?(@config['name'])
    return false unless is_string?(@config['owner'])
    return false unless is_string?(@config['password'])
    return false unless is_bool?(@config['tuning'])
    true
  end
end

class WebserverValidator < BaseValidator
  def validate
    return false unless check_config_has_keys(%w(type siteroot sitedata logroot), @config)
    siterootconf = @config['siteroot']
    return false unless check_config_has_keys(%w(hostpath vmpath), siterootconf)
    sitedataconf = @config['sitedata']
    return false unless check_config_has_keys(%w(hostpath vmpath), sitedataconf)

    allowedtypes = %w(apache nginx)
    return false unless array_contains_var?(allowedtypes, @config['type'])

    return false unless path_exists?(siterootconf['hostpath'])
    return false unless path_exists?(sitedataconf['hostpath'])
    true
  end
end

class LmsValidator < BaseValidator
  def validate
    return false unless check_config_has_keys(%w(sitename adminuser adminpassword adminemail), @config)

    allowedtypes = %w(moodle mahara none)
    return false unless array_contains_var?(allowedtypes, @config['type'])

    return false unless is_string?(@config['sitename'])
    return false unless is_string?(@config['adminuser'])
    return false unless is_string?(@config['adminpassword'])
    return false unless is_string?(@config['adminemail'])

    true
  end
end

class DevtoolsValidator < BaseValidator
  def validate
    return false unless check_config_has_keys(%w(utils moosh xdebug profiling phpunit), @config)
    return false unless is_bool?(@config['utils'])
    return false unless is_bool?(@config['moosh'])
    return false unless is_bool?(@config['xdebug'])
    return false unless is_bool?(@config['profiling'])

    phpunitconf = @config['phpunit']
    return false unless check_config_has_keys(%w(enabled dataroot prefix), phpunitconf)
    return false unless is_bool?(phpunitconf['enabled'])
    return false unless is_string?(phpunitconf['prefix'])
    true
  end
end

def validate_config(config)
  validators = []
  validators.push(VagrantboxValidator.new(config['vagrantbox']))
  validators.push(WebserverValidator.new(config['webserver']))
  validators.push(DatabaseValidator.new(config['database']))
  validators.push(LmsValidator.new(config['lms']))
  validators.push(DevtoolsValidator.new(config['devtools']))

  validators.each do |v|
    unless v.validate
      puts "#{v.class.name} return false. Exiting"
      exit
    end
  end
end
