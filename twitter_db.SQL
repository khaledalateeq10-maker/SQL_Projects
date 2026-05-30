-- Twitter Database Project
-- Created by: Khalid

CREATE DATABASE twitter_db;
USE twitter_db;

-- جدول المستخدمين
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100),
    password BINARY(64),
    created_at DATETIME DEFAULT NOW()
);

-- جدول التغريدات
CREATE TABLE tweets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    user_id INT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- جدول التابعين
CREATE TABLE followers (
    follower_id INT,
    following_id INT,
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (following_id) REFERENCES users(id)
);

-- جدول الإعجابات
CREATE TABLE likes (
    user_id INT,
    tweet_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(id)
);

-- إضافة مستخدمين
INSERT INTO users (username, email, password) VALUES
('Ahmed', 'ahmed@email.com', MD5('pass123')),
('Sara', 'sara@email.com', MD5('pass456')),
('Khalid', 'khalid@email.com', MD5('pass789'));

-- إضافة تغريدات
INSERT INTO tweets (content, user_id) VALUES
('مرحبا بالجميع!', 1),
('يوم جميل', 2),
('أحب البرمجة', 3);

-- إضافة متابعين
INSERT INTO followers (follower_id, following_id) VALUES
(1, 2), (2, 3), (3, 1);

-- إضافة إعجابات
INSERT INTO likes (user_id, tweet_id) VALUES
(1, 2), (2, 3), (3, 1);

-- Procedure createAccount
DELIMITER //
CREATE PROCEDURE createAccount(
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(100)
)
BEGIN
    INSERT INTO users (username, email, password, created_at)
    VALUES (p_username, p_email, MD5(p_password), NOW());
END //
DELIMITER ;

-- Procedure User_Follow
DELIMITER //
CREATE PROCEDURE User_Follow(
    IN p_username VARCHAR(100),
    IN p_target VARCHAR(100)
)
BEGIN
    DECLARE user_id INT;
    DECLARE target_id INT;
    SELECT id INTO user_id FROM users WHERE username = p_username;
    SELECT id INTO target_id FROM users WHERE username = p_target;
    INSERT INTO followers (follower_id, following_id)
    VALUES (user_id, target_id);
END //
DELIMITER ;

-- عرض عدد تغريدات مستخدم
SELECT u.username, COUNT(t.id) AS tweet_count
FROM users u
JOIN tweets t ON u.id = t.user_id
WHERE u.username = 'Ahmed'
GROUP BY u.username;