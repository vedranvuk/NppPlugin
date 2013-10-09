unit NppPluginMain;

interface

uses
	Windows, SysUtils, NppPluginInterface;

const
	NPP_PLUGIN_NAME: PChar        = 'NppPlugin';
	NPP_PLUGIN_MODULE_NAME: PChar = 'NppPlugin.dll';
	NPP_PLUGIN_VERSION: PChar     = '1.0.0';
	NPP_PLUGIN_FUNCTION_COUNT     = 1;

var
	nppData       : TNppData;
	pluginCommands: array [0 .. NPP_PLUGIN_FUNCTION_COUNT - 1] of TNppPluginCommand;

procedure PluginInitialization;
procedure PluginFinalization;
procedure PluginStartup;
procedure PluginShutdown;

implementation

procedure CommandAbout;
begin
	MessageBox(0,
	  PChar('NppPlugin version: ' + NPP_PLUGIN_VERSION + #13#10 +
	  'by AUTHOR' + #13#10 +
	  'author@email.com'),
	  'NppPlugin',
	  MB_ICONINFORMATION or MB_OK
	  );
end;

procedure SetNppPluginCommandData(
  const aIndex: integer;      // Index of command in pluginCommands array.
  const aName: string;        // Command display name as show in npp plugins menu.
  const aFunc: TNppPluginCmd; // Function called when the command is executed.
  const aCmdID: integer;      // CommandID.
  const aInit2Check: boolean;
  const aShortcutCtrl: boolean = False;
  const aShortcutShift: boolean = False;
  const aShortcutAlt: boolean = False;
  const aShortcutKey: byte = 0
  );
begin
	Move(aName[1], pluginCommands[aIndex].itemName[0], Length(aName) * SizeOf(char));
	pluginCommands[aIndex].pFunc      := aFunc;
	pluginCommands[aIndex].cmdID      := aCmdID;
	pluginCommands[aIndex].init2Check := aInit2Check;
	if (aShortcutKey <> 0) then
	begin
		pluginCommands[aIndex].shortcut           := AllocMem(SizeOf(pluginCommands[aIndex].shortcut^));
		pluginCommands[aIndex].shortcut^.ModCTRL  := aShortcutCtrl;
		pluginCommands[aIndex].shortcut^.ModSHIFT := aShortcutShift;
		pluginCommands[aIndex].shortcut^.ModALT   := aShortcutAlt;
		pluginCommands[aIndex].shortcut^.Key      := aShortcutKey;
	end;
end;

{ Plugin initialization, called in process attatch. Do lowest level stuff here. }
procedure PluginInitialization;
begin
	ZeroMemory(@pluginCommands, SizeOf(pluginCommands[0]) * Length(pluginCommands));

	SetNppPluginCommandData(0, 'About...', CommandAbout, 0, False);
end;

{ Plugin finalization, called in process detatch. Do lowest level stuff here }
procedure PluginFinalization;

    procedure FreeNppPluginCommandShortcuts;
    var
        i: integer;
    begin
        for i := 0 to high(pluginCommands) do
        begin
            if (pluginCommands[i].shortcut = nil) then
                Continue;
            FreeMem(pluginCommands[i].shortcut);
            pluginCommands[i].shortcut := nil;
        end;
    end;

begin
	FreeNppPluginCommandShortcuts;
end;

{ Plugin starup, called when notepad++ is ready to work, after the plugin has been initialized. }
procedure PluginStartup;
begin

end;

{ Plugin shutdown, called when notepad++ is about to shutdown, prior to unloading the plugin. }
procedure PluginShutdown;
begin

end;

end.
