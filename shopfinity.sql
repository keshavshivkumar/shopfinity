# create database shopfinity;
use shopfinity; 
CREATE TABLE IF NOT EXISTS EndUsers(
full_name CHAR(20) NOT NULL,
email_id CHAR(25),
ph_no BIGINT UNIQUE NOT NULL,
passwd CHAR(26) NOT NULL,
role_id INT NOT NULL DEFAULT 3,
PRIMARY KEY (email_id)
);

CREATE TABLE IF NOT EXISTS Vehicles(
    vehicle_id INT NOT NULL AUTO_INCREMENT,
    vehicle_name CHAR(25) NOT NULL,
    vehicle_model CHAR(25) NOT NULL,
    vehicle_type CHAR(10),
    PRIMARY KEY (vehicle_id)
);

CREATE TABLE IF NOT EXISTS Bids(
vehicle_id INT,
dt DATETIME,
seller_id CHAR(25) NOT NULL,
buyer_id CHAR(25),
upper_limit INT NOT NULL,
bid_amount INT NOT NULL,
license_plate CHAR(10) NOT NULL,
PRIMARY KEY (vehicle_id, dt, buyer_id),
FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
FOREIGN KEY (buyer_id) REFERENCES EndUsers(email_id) ON DELETE CASCADE,
CHECK (buyer_id <> seller_id)
);
CREATE TABLE IF NOT EXISTS Listings(
    vehicle_id INT,
    dt DATETIME,
    seller_id CHAR(25),
    buyer_id CHAR(25),
    final_bid INT,
    listing_price INT NOT NULL,
    min_price INT,
    min_inc INT,
    sold BOOL,
    expiration_datetime DATETIME,
    license_plate CHAR(10) NOT NULL UNIQUE,
    PRIMARY KEY (vehicle_id, dt, seller_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (seller_id) REFERENCES EndUsers(email_id) ON DELETE CASCADE,
    CHECK (buyer_id <> seller_id)
);

CREATE TABLE IF NOT EXISTS UserRoles (
    role_id INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    can_delete_listings BOOLEAN NOT NULL,
    can_create_users BOOLEAN NOT NULL,
    can_generate_reports BOOLEAN NOT NULL,
    PRIMARY KEY (role_id)
);

CREATE TABLE IF NOT EXISTS Questions (
    question_id INT NOT NULL AUTO_INCREMENT,
    customer_id CHAR(25) NOT NULL,
    representative_id CHAR(25),
    question TEXT NOT NULL,
    answer TEXT,
    asked_datetime DATETIME NOT NULL,
    answered_datetime DATETIME,
    PRIMARY KEY (question_id),
    FOREIGN KEY (customer_id) REFERENCES EndUsers(email_id) ON DELETE CASCADE,
    FOREIGN KEY (representative_id) REFERENCES EndUsers(email_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT NOT NULL AUTO_INCREMENT,
    email_id CHAR(25) NOT NULL,
    notification_text TEXT NOT NULL,
    timestamp_pushed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (notification_id),
    FOREIGN KEY (email_id) REFERENCES EndUsers(email_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Wishlists (
    email_id CHAR(25),
    vehicle_id INT,
    PRIMARY KEY (email_id, vehicle_id),
    FOREIGN KEY (email_id) REFERENCES EndUsers(email_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE
);