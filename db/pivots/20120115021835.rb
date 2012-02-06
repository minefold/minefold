# Adminize us

admins = {"username" => {'$in' => ['chrislloyd', 'whatupdave']}}
db['users'].update admins, {'$set' => {'admin' => true}}
