-- CREATE A MIGRATION ENTRY
INSERT INTO `DB_MIGRATIONS` (`MIGRATION`) VALUES ('20190401_cnr_remove_passive_mode');

-- BEGIN

-- -- REMOVE PASSIVE MODE SETTING
DELETE FROM `SETTINGS` WHERE SETTING_ID = 12;