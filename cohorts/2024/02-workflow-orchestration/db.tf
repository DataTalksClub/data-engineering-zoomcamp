# db.tf | Database Configuration

resource "google_sql_database_instance" "instance" {
    name                = "${var.app_name}-db-instance"
    region              = var.region
    database_version    = "POSTGRES_14"
    deletion_protection = false
    settings {
        tier            = "db-f1-micro"
        database_flags {
            name  = "max_connections"
            value = "50"
        }
    }
}

resource "google_sql_database" "database"{
    name                = "${var.app_name}-db"
    instance            = google_sql_database_instance.instance.name
}

resource "google_sql_user" "database-user" {
    name        = var.database_user
    instance    = google_sql_database_instance.instance.name
    password    = var.database_password
}
