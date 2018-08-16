﻿// This file contains your Data Connector logic
section JamfPro___Get_Categories;

[DataSource.Kind="JamfPro___Get_Categories", Publish="JamfPro___Get_Categories.Publish"]
shared JamfPro___Get_Categories.Contents = (website as text) =>
        let
        token = GetJamfProToken(website),
        source = GetPatchReport(website, token)

    in
        source;
GetJamfProToken = (website as text) =>
    let
        username = Record.Field(Extension.CurrentCredential(), "Username"),
        password = Record.Field(Extension.CurrentCredential(), "Password"),
        bytes = Text.ToBinary(username & ":" & password),
        credentials = Binary.ToText(bytes, BinaryEncoding.Base64),
        source = Web.Contents(website & "/uapi/auth/tokens",
        [
            Headers = [#"Authorization" = "Basic " & credentials,
                #"Accepts" = "application/json"],
            Content=Text.ToBinary(" ")
        ]),
        json = Json.Document(source),
        first = Record.Field(json,"token"),
        auth = Extension.CurrentCredential(),
        auth2 = Record.Field(auth, "Password")
    in
        first;

GetPatchReport = (website as text, token as text) =>
    let
        source = Web.Contents(website & "/uapi/settings/obj/category",
        [
            Headers = [#"Authorization" = "jamf-token " & token,
                #"Accepts" = "application/json"]]),
        json = Json.Document(source)
    in
        json;
// Data Source Kind description
JamfPro___Get_Categories = [
    Authentication = [
        // Key = [],
        UsernamePassword = []
        // Windows = [],
        //Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
JamfPro___Get_Categories.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = JamfPro___Get_Categories.Icons,
    SourceTypeImage = JamfPro___Get_Categories.Icons
];

JamfPro___Get_Categories.Icons = [
    Icon16 = { Extension.Contents("JamfPro___Get_Categories16.png"), Extension.Contents("JamfPro___Get_Categories20.png"), Extension.Contents("JamfPro___Get_Categories24.png"), Extension.Contents("JamfPro___Get_Categories32.png") },
    Icon32 = { Extension.Contents("JamfPro___Get_Categories32.png"), Extension.Contents("JamfPro___Get_Categories40.png"), Extension.Contents("JamfPro___Get_Categories48.png"), Extension.Contents("JamfPro___Get_Categories64.png") }
];
