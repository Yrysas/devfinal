CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    user_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    order_id BIGINT,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

INSERT INTO users (name, email) VALUES ('John Doe', 'john.doe@example.com');
INSERT INTO users (name, email) VALUES ('Jane Smith', 'jane.smith@example.com');

INSERT INTO orders (order_date, total_amount, user_id) VALUES (NOW(), 100.00, 1);
INSERT INTO orders (order_date, total_amount, user_id) VALUES (NOW(), 150.00, 2);

INSERT INTO items (name, price, order_id) VALUES ('Item 1', 50.00, 1);
INSERT INTO items (name, price, order_id) VALUES ('Item 2', 50.00, 1);
INSERT INTO items (name, price, order_id) VALUES ('Item 3', 150.00, 2);