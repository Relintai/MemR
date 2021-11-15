#include <string.h>
#include <iostream>
#include <string>

#include "core/bry_http/http_server.h"
#include "core/file_cache.h"
#include "core/http/web_application.h"

#include "database/db_init.h"

#include "core/settings.h"

#include "core/http/session_manager.h"

//Backends
#include "backends/hash_hashlib/setup.h"

#include "core/os/platform.h"
#include "platform/platform_initializer.h"

#include "core/database/database_manager.h"

void initialize_backends() {
	initialize_database_backends();
	backend_hash_hashlib_install_providers();
}

void create_databases() {
	DatabaseManager *dbm = DatabaseManager::get_singleton();

	uint32_t index = dbm->create_database("sqlite");
	Database *db = dbm->databases[index];
	db->connect("database.sqlite");
}

int main(int argc, char **argv, char **envp) {
	PlatformInitializer::allocate_all();
	PlatformInitializer::arg_setup(argc, argv, envp);

	initialize_backends();

	::SessionManager *session_manager = new ::SessionManager();

	Settings *settings = new Settings(true);
	//settings->parse_file("settings.json");

	FileCache *file_cache = new FileCache(true);
	file_cache->wwwroot = "./www";
	file_cache->wwwroot_refresh_cache();

	DatabaseManager *dbm = new DatabaseManager();

	create_databases();

	delete dbm;
	delete file_cache;
	delete settings;
	delete session_manager;

	PlatformInitializer::free_all();

	return 0;
}