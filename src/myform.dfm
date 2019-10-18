object Form1: TForm1
  Left = 196
  Top = 486
  Cursor = crHelp
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 204
  ClientWidth = 361
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDblClick = FormClick
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object gui: TPanel
    Left = 0
    Top = 0
    Width = 361
    Height = 204
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 22
    TabOrder = 0
    Visible = False
    object splitter: TSplitter
      Left = 115
      Top = 0
      Width = 6
      Height = 204
      Color = clBtnShadow
      ParentColor = False
      ResizeStyle = rsUpdate
      OnMoved = splitterMoved
    end
    object splitstack: TSplitter
      Left = 49
      Top = 0
      Width = 2
      Height = 204
      Color = clBlack
      MinSize = 10
      ParentColor = False
    end
    object viewer: TPanel
      Left = 121
      Top = 0
      Width = 240
      Height = 204
      Align = alClient
      BevelOuter = bvNone
      Caption = 'viewer'
      Constraints.MinHeight = 202
      Constraints.MinWidth = 238
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object control: TPanel
        Left = 0
        Top = 182
        Width = 240
        Height = 22
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object b_take: TButton
          Left = 120
          Top = 0
          Width = 38
          Height = 25
          Hint = 'Copy selected item to clipboard'
          Caption = 'Take'
          TabOrder = 3
          OnClick = b_takeClick
        end
        object b_delete: TButton
          Left = 160
          Top = 0
          Width = 38
          Height = 25
          Hint = 'Delete selected item '#8211' Win+Ctrl+D'
          Caption = 'Delete'
          TabOrder = 4
          OnClick = b_deleteClick
        end
        object b_htm: TButton
          Left = 80
          Top = 0
          Width = 38
          Height = 25
          Hint = 'Show HTM format'
          Caption = 'HTM'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = b_htmClick
          OnMouseDown = b_MouseDown
        end
        object b_rtf: TButton
          Left = 40
          Top = 0
          Width = 38
          Height = 25
          Hint = 'Show RTF format'
          Caption = 'RTF'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = b_rtfClick
          OnMouseDown = b_MouseDown
        end
        object b_txt: TButton
          Left = 0
          Top = 0
          Width = 38
          Height = 25
          Hint = 'Show TXT format'
          BiDiMode = bdLeftToRight
          Caption = 'TXT'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentBiDiMode = False
          ParentFont = False
          TabOrder = 0
          OnClick = b_txtClick
          OnMouseDown = b_MouseDown
        end
        object b_trim: TButton
          Left = 200
          Top = 0
          Width = 38
          Height = 25
          Hint = 'Trim current clipboard contents to text-only '#8211' Win+Ctrl+C'
          Caption = 'Trim'
          TabOrder = 5
          OnClick = b_trimClick
        end
      end
      object display: TPanel
        Left = 0
        Top = 0
        Width = 240
        Height = 182
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object e_txt: TMemo
          Left = 0
          Top = 0
          Width = 240
          Height = 182
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial Unicode MS'
          Font.Style = []
          ImeMode = imAlpha
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          Visible = False
          WantReturns = False
        end
        object e_rtf: TRichEdit
          Left = 0
          Top = 0
          Width = 240
          Height = 182
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 1
          Visible = False
          WantReturns = False
        end
        object p_htm: TPanel
          Left = 0
          Top = 0
          Width = 240
          Height = 182
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 2
          object e_htm: TWebBrowser
            Left = 0
            Top = 0
            Width = 240
            Height = 182
            Align = alClient
            TabOrder = 0
            ControlData = {
              4C000000CE180000CF1200000000000000000000000000000000000000000000
              000000004C000000000000000000000001000000E0D057007335CF11AE690800
              2B2E126203000000000000004C0000000114020000000000C000000000000046
              8000000000000000000000000000000000000000000000000000000000000000
              00000000000000000100000000000000000000000000000000000000}
          end
        end
        object p_settings: TPanel
          Left = 0
          Top = -1
          Width = 241
          Height = 183
          Align = alCustom
          Alignment = taLeftJustify
          Anchors = [akLeft, akBottom]
          BevelOuter = bvNone
          TabOrder = 3
          object p_helper: TPanel
            Left = 0
            Top = 4
            Width = 241
            Height = 179
            Align = alBottom
            Alignment = taLeftJustify
            BevelOuter = bvNone
            TabOrder = 0
            OnClick = p_helperClick
            object l_maxhist: TLabel
              Left = 12
              Top = 31
              Width = 81
              Height = 16
              Caption = 'History items:'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object l_maxline: TLabel
              Left = 4
              Top = 77
              Width = 93
              Height = 16
              Caption = 'Max string, MB:'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object l_autosave: TLabel
              Left = 6
              Top = 54
              Width = 90
              Height = 16
              Caption = 'Autosave, Min.:'
              Enabled = False
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object e_maxhist: TSpinEdit
              Left = 100
              Top = 27
              Width = 67
              Height = 22
              Hint = 'Limit maximal history items count. Not applied to paste-list.'
              MaxValue = 0
              MinValue = 0
              TabOrder = 4
              Value = 0
              OnExit = setsave
              OnKeyDown = setkey
            end
            object e_maxstr: TSpinEdit
              Left = 100
              Top = 75
              Width = 67
              Height = 22
              Hint = 
                'Ignore too long strings when coping from clipboard, but size of ' +
                'RTF or HTM formats can be huge!'
              MaxValue = 0
              MinValue = 0
              TabOrder = 6
              Value = 0
              OnExit = setsave
              OnKeyDown = setkey
            end
            object r_all1: TRadioButton
              Left = 95
              Top = 100
              Width = 89
              Height = 17
              Hint = 'Make "ALL" get everything from paste-list without delimiters'
              Caption = 'ALL: as is'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
              OnClick = setclick
            end
            object r_all2: TRadioButton
              Left = 95
              Top = 116
              Width = 97
              Height = 17
              Hint = 'Make "ALL" get everything from paste-list by new lines'
              Caption = 'ALL: newline'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 13
              OnClick = setclick
            end
            object r_all3: TRadioButton
              Left = 95
              Top = 132
              Width = 105
              Height = 17
              Hint = 'Make "ALL" get everything by new lines including timestamps'
              Caption = 'ALL: +time'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 14
              OnClick = setclick
            end
            object e_autosave: TSpinEdit
              Left = 100
              Top = 51
              Width = 67
              Height = 22
              Hint = 'Export to "AUTOSAVE" file every N minutes; zero to disable.'
              MaxValue = 0
              MinValue = 0
              TabOrder = 5
              Value = 0
              OnExit = setsave
              OnKeyDown = setkey
            end
            object c_itxt: TCheckBox
              Left = 4
              Top = 120
              Width = 89
              Height = 25
              Hint = 'Do not display TXT in any way'
              Caption = 'Ignore TXT'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 15
              OnClick = setclick
            end
            object c_irtf: TCheckBox
              Left = 4
              Top = 142
              Width = 89
              Height = 17
              Hint = 'Do not display RTF in any way'
              Caption = 'Ignore RTF'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              OnClick = setclick
            end
            object c_ihtm: TCheckBox
              Left = 4
              Top = 159
              Width = 89
              Height = 17
              Hint = 'Do not display HTM in any way'
              Caption = 'Ignore HTM'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 17
              OnClick = setclick
            end
            object c_saveexit: TCheckBox
              Left = 94
              Top = 4
              Width = 97
              Height = 17
              Hint = 'Export to "LASTCLOSE" file when quitting application'
              Caption = 'Save on exit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = setclick
            end
            object b_all: TButton
              Left = 146
              Top = 152
              Width = 41
              Height = 24
              Hint = 'Get all dumped from paste-list - Win+Ctrl+A'
              Caption = 'ALL !'
              TabOrder = 19
              OnClick = b_allClick
            end
            object b_paste: TButton
              Left = 100
              Top = 152
              Width = 41
              Height = 24
              Hint = 'Dump clipboard to paste-list - Win+Ctrl+V'
              Caption = 'Paste'
              TabOrder = 18
              OnClick = b_pasteClick
            end
            object b_export: TButton
              Left = 47
              Top = 1
              Width = 41
              Height = 25
              Hint = 'Save lists to special file'
              Caption = 'Export'
              TabOrder = 1
              OnClick = b_exportClick
            end
            object b_import: TButton
              Left = 4
              Top = 1
              Width = 41
              Height = 25
              Hint = 'Load lists from a file'
              Caption = 'Import'
              TabOrder = 0
              OnClick = b_importClick
            end
            object b_reset: TButton
              Left = 173
              Top = 67
              Width = 63
              Height = 25
              Hint = 'Reset window position (small too)'
              Caption = 'Reset pos.'
              TabOrder = 9
              WordWrap = True
              OnClick = b_resetClick
            end
            object b_redo: TButton
              Left = 47
              Top = 97
              Width = 40
              Height = 25
              Hint = 'Go one item down in history list - Win+Ctrl+Shift+Z'
              Caption = 'Redo'
              TabOrder = 11
              OnClick = b_redoClick
            end
            object b_undo: TButton
              Left = 4
              Top = 97
              Width = 41
              Height = 25
              Hint = 'Go one item up in history list - Win+Ctrl+Z'
              Caption = 'Undo'
              TabOrder = 10
              OnClick = b_undoClick
            end
            object b_quit: TButton
              Left = 191
              Top = 1
              Width = 44
              Height = 25
              Hint = 
                'Close program completely. Simple Alt+F4 won`t work until main wi' +
                'ndow is shown!'
              Caption = 'Quit'
              TabOrder = 3
              OnClick = b_quitClick
            end
            object b_close: TButton
              Left = 192
              Top = 124
              Width = 44
              Height = 24
              Hint = 'Close to small square'
              Caption = '[Close]'
              TabOrder = 20
              WordWrap = True
              OnClick = b_closeClick
            end
            object b_help: TButton
              Left = 192
              Top = 96
              Width = 44
              Height = 24
              Hint = 'General help'
              Caption = 'Help'
              TabOrder = 8
              WordWrap = True
              OnClick = b_helpClick
            end
            object b_toggle: TButton
              Left = 173
              Top = 31
              Width = 63
              Height = 32
              Hint = 'Toggle logging of clipboard changes'
              Caption = 'DISABLE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 7
              WordWrap = True
              OnClick = b_toggleClick
            end
            object b_min: TButton
              Left = 192
              Top = 152
              Width = 44
              Height = 24
              Hint = 'Minimize to tray icon'
              Caption = '[Min]'
              TabOrder = 21
              WordWrap = True
              OnClick = b_minClick
            end
          end
        end
      end
    end
    object list: TListBox
      Left = 51
      Top = 0
      Width = 64
      Height = 204
      Hint = 
        'Clipboard history list, everything goes here. Double click an it' +
        'em to "Take" it; Insert key works as the "Trim"'
      Style = lbOwnerDrawFixed
      AutoComplete = False
      Align = alLeft
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Constraints.MinWidth = 16
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = listClick
      OnDblClick = listDblClick
      OnEnter = listEnter
      OnKeyDown = listKeyDown
      OnMouseDown = listMouseDown
    end
    object stack: TListBox
      Left = 0
      Top = 0
      Width = 49
      Height = 204
      Hint = 
        'Paste-list. Use "Paste" (or Insert key here) to add; "ALL" to ge' +
        't back. "Take" and "Delete" also works. '
      Style = lbOwnerDrawFixed
      AutoComplete = False
      Align = alLeft
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Constraints.MinWidth = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = listClick
      OnDblClick = listDblClick
      OnEnter = stackEnter
      OnKeyDown = listKeyDown
    end
  end
  object mouse: TTimer
    Enabled = False
    Interval = 10
    OnTimer = mouseTimer
  end
  object colortime: TTimer
    Interval = 100
    OnTimer = colortimeTimer
    Left = 24
  end
  object check: TTimer
    Interval = 200
    OnTimer = checkTimer
    Left = 48
  end
  object menu: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 48
    Top = 24
    object menu_show: TMenuItem
      Caption = 'Show main window | Win+Crtl+X'
      OnClick = menu_showClick
    end
    object menu_trim: TMenuItem
      Caption = 'Trim clipboard text | Win+Ctrl+C'
      OnClick = menu_trimClick
    end
    object menu_paste: TMenuItem
      Caption = 'Dump clipboard | Win+Ctrl+V'
      OnClick = menu_pasteClick
    end
    object menu_all: TMenuItem
      Caption = 'Get all dumped | Win+Ctrl+A'
      OnClick = menu_allClick
    end
    object menu_save: TMenuItem
      Caption = 'Save buffers | Win+Ctrl+S'
      OnClick = menu_saveClick
    end
    object menu_undo: TMenuItem
      Caption = 'Undo   | Win+Ctrl+Z'
      OnClick = menu_undoClick
    end
    object menu_redo: TMenuItem
      Caption = 'Redo   | Win+Ctrl+Shift+Z'
      OnClick = menu_redoClick
    end
    object menu_delete: TMenuItem
      Caption = 'Delete | Win+Ctrl+D'
      OnClick = menu_deleteClick
    end
    object menu_toggle: TMenuItem
      Caption = 'Toggle logging | Win+Ctrl+Q'
      OnClick = menu_toggleClick
    end
    object menu_sep: TMenuItem
      Caption = '--- Logging enabled ---'
      Enabled = False
    end
    object menu_reset: TMenuItem
      Caption = 'Reset window position'
      OnClick = menu_resetClick
    end
    object menu_exit: TMenuItem
      Caption = 'Quit   | Alt+F4'
      Default = True
      OnClick = menu_exitClick
    end
    object menu_mode: TMenuItem
      Caption = 'Tray <> Square'
      OnClick = menu_modeClick
    end
  end
  object save_file: TSaveDialog
    Options = [ofOverwritePrompt, ofNoChangeDir, ofPathMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 24
    Top = 24
  end
  object open_file: TOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofNoTestFileCreate, ofEnableSizing, ofDontAddToRecent]
    Left = 1
    Top = 24
  end
  object t_autosave: TTimer
    Enabled = False
    OnTimer = t_autosaveTimer
    Left = 80
  end
end
