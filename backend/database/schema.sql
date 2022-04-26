CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS Migrations;
DROP TABLE IF EXISTS Media;
DROP TABLE IF EXISTS Experience;
DROP TABLE IF EXISTS Skills;
DROP TABLE IF EXISTS SkillSections;
DROP TABLE IF EXISTS AwardLinks;
DROP TABLE IF EXISTS Awards;
DROP TABLE IF EXISTS Education;
DROP TABLE IF EXISTS ProjectLinks;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS About;
DROP TABLE IF EXISTS Users;

DROP TYPE IF EXISTS Level;
DROP TYPE IF EXISTS MediaType;

CREATE TABLE Users (
    userID uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR(20),
    password VARCHAR(256),
    PRIMARY KEY (userID)
);

CREATE TABLE About (
    aboutID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255),
    title VARCHAR(255),
    about VARCHAR(255),
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (aboutID)
);

CREATE TABLE  Projects (
    projectID uuid DEFAULT uuid_generate_v4 (),
    title VARCHAR(255),
    type VARCHAR(255),
    description VARCHAR(255),
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (projectID)
);

CREATE TABLE ProjectLinks (
    projectLinkID uuid DEFAULT uuid_generate_v4 (),
    text VARCHAR(255),
    link VARCHAR(2048),
    projectID uuid,
    FOREIGN KEY (projectID) REFERENCES Projects (projectID),
    PRIMARY KEY (projectLinkID)
);

CREATE TABLE Education (
    educationID uuid DEFAULT uuid_generate_v4 (),
    diploma VARCHAR(255),
    school VARCHAR(255),
    startDate DATE,
    endDate DATE,
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (educationID)
);

CREATE TABLE Awards (
    awardID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255),
    date DATE,
    description VARCHAR(255),
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (awardID)
);

CREATE TABLE AwardLinks (
    awardLinkID uuid DEFAULT uuid_generate_v4 (),
    text VARCHAR(255),
    link VARCHAR(2048),
    awardID uuid,
    FOREIGN KEY (awardID) REFERENCES Awards (awardID),
    PRIMARY KEY (awardLinkID)
);

CREATE TABLE SkillSections (
    skillSectionID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255),
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (skillSectionID)
);

CREATE TYPE LEVEL AS ENUM ('Beginner', 'Average', 'Skilled', 'Expert');

CREATE TABLE Skills (
    skillID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255),
    level VARCHAR(255),
    skillSectionID uuid,
    userID uuid,
    FOREIGN KEY (skillSectionID) REFERENCES SkillSections (skillSectionID),
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (skillID)
);

CREATE TABLE Experience (
    experienceID uuid DEFAULT uuid_generate_v4 (),
    organization VARCHAR(255),
    jobTitle VARCHAR(255),
    startDate DATE,
    endDate DATE,
    description VARCHAR(255),
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (experienceID)
);

CREATE TYPE MediaType AS ENUM ('Twitter', 'LinkedIn', 'GitHub', 'Other');

CREATE TABLE Media (
    mediaID uuid DEFAULT uuid_generate_v4 (),
    mediaType MediaType,
    text  VARCHAR(255),
    link  VARCHAR(2048),
    userID uuid,
    FOREIGN KEY (userID) REFERENCES Users (userID),
    PRIMARY KEY (mediaID)
);

CREATE TABLE Migrations (
    migrationID uuid DEFAULT uuid_generate_v4 (),
    migrationName  VARCHAR(255),
    date DATE,
    PRIMARY KEY (migrationID)
);