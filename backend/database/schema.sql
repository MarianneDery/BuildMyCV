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

DROP FUNCTION IF EXISTS check_skill_section_user;

CREATE TABLE Users (
    userID uuid DEFAULT uuid_generate_v4 (),
    username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Users PRIMARY KEY (userID)
);

CREATE TABLE About (
    aboutID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    about VARCHAR(5000),
    userID uuid UNIQUE NOT NULL,
    CONSTRAINT fk_About_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_About PRIMARY KEY (aboutID)
);

CREATE TABLE  Projects (
    projectID uuid DEFAULT uuid_generate_v4 (),
    title VARCHAR(255) NOT NULL,
    type VARCHAR(255),
    description VARCHAR(5000),
    userID uuid NOT NULL,
    CONSTRAINT fk_Projects_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_Projects PRIMARY KEY (projectID)
);

CREATE TABLE ProjectLinks (
    projectLinkID uuid DEFAULT uuid_generate_v4 (),
    text VARCHAR(255),
    link VARCHAR(2048) NOT NULL,
    projectID uuid NOT NULL,
    CONSTRAINT fk_ProjectLinks_projectID FOREIGN KEY (projectID) REFERENCES Projects (projectID) ON DELETE CASCADE,
    CONSTRAINT pk_ProjectLinks PRIMARY KEY (projectLinkID)
);

CREATE TABLE Education (
    educationID uuid DEFAULT uuid_generate_v4 (),
    diploma VARCHAR(255) NOT NULL,
    school VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    userID uuid NOT NULL,
    CONSTRAINT fk_Education_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_Education PRIMARY KEY (educationID)
);

CREATE TABLE Awards (
    awardID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255) NOT NULL,
    date DATE,
    description VARCHAR(5000),
    userID uuid NOT NULL,
    CONSTRAINT fk_Awards_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_Awards PRIMARY KEY (awardID)
);

CREATE TABLE AwardLinks (
    awardLinkID uuid DEFAULT uuid_generate_v4 (),
    text VARCHAR(255),
    link VARCHAR(2048) NOT NULL,
    awardID uuid NOT NULL,
    CONSTRAINT fk_AwardLinks_awardID FOREIGN KEY (awardID) REFERENCES Awards (awardID) ON DELETE CASCADE,
    CONSTRAINT pk_AwardLinks PRIMARY KEY (awardLinkID)
);

CREATE TABLE SkillSections (
    skillSectionID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255) NOT NULL,
    userID uuid NOT NULL,
    CONSTRAINT fk_SkillSections_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_SkillSections PRIMARY KEY (skillSectionID)
);

CREATE TYPE LEVEL AS ENUM ('Beginner', 'Average', 'Skilled', 'Expert');

CREATE TABLE Skills (
    skillID uuid DEFAULT uuid_generate_v4 (),
    name VARCHAR(255) NOT NULL,
    level VARCHAR(255) NOT NULL,
    skillSectionID uuid,
    userID uuid NOT NULL,
    CONSTRAINT fk_Skills_skillSectionID FOREIGN KEY (skillSectionID) REFERENCES SkillSections (skillSectionID) ON DELETE SET NULL,
    CONSTRAINT fk_Skills_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_Skills PRIMARY KEY (skillID)
);

CREATE FUNCTION check_skill_section_user() RETURNS trigger AS $check_skill_section_user$
    BEGIN
        IF ((NEW.skillSectionID IS NOT NULL) AND ((SELECT COUNT(S.skillSectionID) FROM SkillSections S WHERE S.skillSectionID = NEW.skillSectionID AND S.userID = NEW.userID) =  0)) THEN
            RAISE EXCEPTION 'The skillSectionID has to belong to the user defined by userID.';
        END IF;
        RETURN NEW;
    END;
$check_skill_section_user$ LANGUAGE plpgsql;

CREATE TRIGGER check_skill_section_user BEFORE INSERT OR UPDATE ON Skills
    FOR EACH ROW EXECUTE PROCEDURE check_skill_section_user();

CREATE TABLE Experience (
    experienceID uuid DEFAULT uuid_generate_v4 (),
    organization VARCHAR(255) NOT NULL,
    jobTitle VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,                                   /*Note: An endDate of Null means the user is currently employed by the company*/
    description VARCHAR(5000),
    userID uuid NOT NULL,
    CONSTRAINT fk_Experience_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_Experience PRIMARY KEY (experienceID)
);

CREATE TYPE MediaType AS ENUM ('Twitter', 'LinkedIn', 'GitHub', 'Other');

CREATE TABLE Media (
    mediaID uuid DEFAULT uuid_generate_v4 (),
    mediaType MediaType NOT NULL,
    text  VARCHAR(255),
    link  VARCHAR(2048) NOT NULL,
    userID uuid NOT NULL,
    CONSTRAINT fk_Media_userID FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    CONSTRAINT pk_Media PRIMARY KEY (mediaID)
);

CREATE TABLE Migrations (
    migrationID uuid DEFAULT uuid_generate_v4 (),
    migrationName  VARCHAR(255) NOT NULL,
    date DATE,
    CONSTRAINT pk_Migrations PRIMARY KEY (migrationID)
);