def is_string?(var)
    if var.respond_to?(:to_str)
        return true;
    end
    puts "#{var} does not respond to to_str"
    return false
end

def array_contains?(array, var)
    if array.include?(var)
        return true
    end
    puts "#{var} is not in #{array}"
    return false
end

def is_int?(var)
    if var.respond_to?(:to_int)
        return true;
    end
    puts "#{var} does not respond to to_int"
    return false
end

def validate_database_config(databaseConf)
    type = databaseConf['type']
    allowedtypes = ['pgsql', 'mysql']
    unless array_contains?(allowedtypes, type)
        return false
    end

    name = databaseConf['name']
    unless is_string?(name)
        return false
    end

    owner = databaseConf['owner']
    unless is_string?(owner)
        return false
    end

    password = databaseConf['password']
    unless is_string?(password)
        return false
    end

    return true
end

def validate_moodle_config(moodleConf)
    sitename = moodleConf['sitename']
    unless is_string?(sitename)
        return false
    end

    adminuser = moodleConf['adminuser']
    unless is_string?(adminuser)
        return false
    end

    adminpassword = moodleConf['adminpassword']
    unless is_string?(adminpassword)
        return false
    end

    return true
end

def validate_virtualbox_config(virtualboxConf)
    memory = virtualboxConf['memory']
    unless is_int?(memory)
        return false
    end

    cores = virtualboxConf['cores']
    unless is_int?(cores)
        return false
    end

    return true
end

def validate_environment_config(environmentConf)
    base = environmentConf['base']
    allowedbases = ['ubuntu/trusty64', 'ubuntu/xenial64']
    unless array_contains?(allowedbases, base)
        return false
    end

    name = environmentConf['name']
    unless is_string?(name)
        return false
    end

    name = environmentConf['name']
    unless is_string?(name)
        return false
    end

    phpversion = environmentConf['phpversion']
    allowedphps = [5, 7]
    unless array_contains?(allowedphps, phpversion)
        return false
    end

    return true
end

def path_exists?(path)
    path = Pathname.new(path)
    if path.exist?
        return true
    end
    puts "Path #{path} does not exist"
    return false
end

def validate_siteroot_config(siterootConf)
    hostpath = siterootConf['hostpath']
    unless path_exists?(hostpath)
        return false
    end

    vmpath = siterootConf['vmpath']
    #no validation as of yet

    return true
end

def validate_config(config)
    unless validate_database_config(config['database'])
        puts 'Database config validation failed. Exiting.'
        exit
    end

    unless validate_moodle_config(config['moodle'])
        puts 'Moodle config validation failed. Exiting.'
        exit
    end

    unless validate_virtualbox_config(config['virtualbox'])
        puts 'Virtualbox config validation failed. Exiting.'
        exit
    end

    unless validate_environment_config(config['environment'])
        puts 'Environment config validation failed. Exiting.'
        exit
    end

     unless validate_siteroot_config(config['siteroot'])
        puts 'Siteroot config validation failed. Exiting.'
        exit
    end
end

