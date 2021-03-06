library NppPlugin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$R 'Resources.res' 'Resources.rc'}

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages,
  NppPluginInterface,
  NppPluginMain in 'NppPluginMain.pas';

{ Gives notepad++ data to the plugin. }
procedure setInfo(aNppData: TNppData); cdecl;
begin
	nppData := aNppData;
	PluginInitialization;
end;

{ Returns plugin name to notepad++. }
function getName: PChar; cdecl;
begin
	Result := NPP_PLUGIN_NAME;
end;

{ Returns function definitions array pointer to notepadd++. }
function getFuncsArray(aFuncCount: pinteger): PNppPluginCommandShortcut; cdecl;
begin
	aFuncCount^ := NPP_PLUGIN_FUNCTION_COUNT;
	Result      := @pluginCommands;
end;

{ Receives Scintilla notifications from notepad++. }
procedure beNotified(aNotifyCode: PSCNotification); cdecl;
begin
	case aNotifyCode.nmhdr.code of
		NPPN_READY:
		PluginStartup;
		NPPN_SHUTDOWN:
		PluginShutdown;
	end;
end;

{ Plugin msg proc. }
function messageProc(aMsg: UINT; aWParam: WPARAM; aLParam: LPARAM): LRESULT; cdecl;
begin
	Result := 0;
end;

{ Is plugin Unicode. }
function isUnicode: BOOL; cdecl;
begin
	Result := {$IFDEF UNICODE}True{$ELSE}False{$ENDIF};
end;

{ Entry procedure. }
procedure EntryProc(aEntryCode: integer);
begin
	case aEntryCode of
		DLL_PROCESS_ATTACH:
		PluginInitialization;
		DLL_PROCESS_DETACH:
		PluginFinalization;
	end;
end;

exports
	setInfo name 'setInfo',
	getName name 'getName',
	getFuncsArray name 'getFuncsArray',
	beNotified name 'beNotified',
	messageProc name 'messageProc',
	isUnicode name 'isUnicode';

begin
{$IFDEF DEBUG}
	ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
	DllProc := @EntryProc;
	EntryProc(DLL_PROCESS_ATTACH);

end.
