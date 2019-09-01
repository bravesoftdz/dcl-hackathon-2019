program image_service;

{$mode delphi}{$H+}

uses
  SysUtils,
  fphttpapp,
  config.types,
  controller.base,
  controller.registration,
  controller.status,
  controller.image;

const
  CONFIG_NAME = 'image_service_config.json';
var
  LConfig : IJSONConfig;
  LError: String;
begin
  //create and load config if one exists
  LConfig := CreateJSONConfig;

  if not FileExists(CONFIG_NAME) then
  begin
    LConfig.UpsertValue('port', '8080'); //set default port
    LConfig.UpsertValue('datbaseName', 'image_service.sqlite3'); //default db name

    if not LConfig.SaveToFile(CONFIG_NAME, LError) then
      WriteLn(LError);
  end
  else
    if not LConfig.LoadFromFile(CONFIG_NAME, LError) then
      WriteLn(LError);

  //set the database name for the image service
  DEFAULT_DB_NAME := LConfig['databaseName'];

  //init web app
  Application.Title:='image_service';
  Application.Port:=StrToIntDef(LConfig['port'], 8080); //shouldn't fail, but default here
  Application.Threaded:=True; //thread for every request
  Application.Initialize;
  Application.Run;
end.

