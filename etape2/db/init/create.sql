CREATE TABLE IF NOT EXISTS messages (
id INT AUTO_INCREMENT PRIMARY KEY,
content VARCHAR(255) NOT NULL,
created_at TIMESTAMP DEFALUT CURRENT_TIMESTAMP
);
INSERT INTO messages (content) VALUES ('Hello from create.sql initialization');
