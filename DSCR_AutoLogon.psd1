#
# モジュール 'DSCR_AutoLogon' のモジュール マニフェスト
#
# 生成者: mkht
#
# 生成日: 2016/12/27
#

@{

# このマニフェストに関連付けられているスクリプト モジュール ファイルまたはバイナリ モジュール ファイル。
RootModule = 'DSCR_AutoLogon.psm1'

# このモジュールのバージョン番号です。
ModuleVersion = '2.0.1'

# サポートされている PSEditions
# CompatiblePSEditions = @()

# このモジュールを一意に識別するために使用される ID
GUID = 'b83ee698-75a5-4c41-b87a-73477277467f'

# このモジュールの作成者
Author = 'mkht'

# このモジュールの会社またはベンダー
CompanyName = ''

# このモジュールの著作権情報
Copyright = '(c) 2017 mkht. All rights reserved.'

# このモジュールの機能の説明
Description = 'PowerShell DSC Resource to turn on / off automatic logon in Windows.'

# このモジュールに必要な Windows PowerShell エンジンの最小バージョン
PowerShellVersion = '4.0'

# このモジュールに必要な Windows PowerShell ホストの名前
# PowerShellHostName = ''

# このモジュールに必要な Windows PowerShell ホストの最小バージョン
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# このモジュールに必要なプロセッサ アーキテクチャ (なし、X86、Amd64)
# ProcessorArchitecture = ''

# このモジュールをインポートする前にグローバル環境にインポートされている必要があるモジュール
# RequiredModules = @()

# このモジュールをインポートする前に読み込まれている必要があるアセンブリ
# RequiredAssemblies = @()

# このモジュールをインポートする前に呼び出し元の環境で実行されるスクリプト ファイル (.ps1)。
# ScriptsToProcess = @()

# このモジュールをインポートするときに読み込まれる型ファイル (.ps1xml)
# TypesToProcess = @()

# このモジュールをインポートするときに読み込まれる書式ファイル (.ps1xml)
# FormatsToProcess = @()

# RootModule/ModuleToProcess に指定されているモジュールの入れ子になったモジュールとしてインポートするモジュール
# NestedModules = @()

# このモジュールからエクスポートする関数です。最適なパフォーマンスを得るには、ワイルドカードを使用せず、エクスポートする関数がない場合は、エントリを削除しないで空の配列を使用してください。
FunctionsToExport = @(
    'Set-AutoLogon',
    'Disable-AutoLogon'
)

# このモジュールからエクスポートするコマンドレットです。最適なパフォーマンスを得るには、ワイルドカードを使用せず、エクスポートするコマンドレットがない場合は、エントリを削除しないで空の配列を使用してください。
CmdletsToExport = @()

# このモジュールからエクスポートする変数
VariablesToExport = '*'

# このモジュールからエクスポートするエイリアスです。最適なパフォーマンスを得るには、ワイルドカードを使用せず、エクスポートするエイリアスがない場合は、エントリを削除しないで空の配列を使用してください。
AliasesToExport = @()

# このモジュールからエクスポートする DSC リソース
DscResourcesToExport = 'cAutoLogon'

# このモジュールに同梱されているすべてのモジュールのリスト
# ModuleList = @()

# このモジュールに同梱されているすべてのファイルのリスト
# FileList = @()

# RootModule/ModuleToProcess に指定されているモジュールに渡すプライベート データ。これには、PowerShell で使用される追加のモジュール メタデータを含む PSData ハッシュテーブルが含まれる場合もあります。
PrivateData = @{

    PSData = @{

        # このモジュールに適用されているタグ。オンライン ギャラリーでモジュールを検出する際に役立ちます。
        Tags = ('DesiredStateConfiguration','DSC','DSCResource', 'AutoLogon')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/mkht/DSCR_AutoLogon/blob/master/LICENSE'

        # このプロジェクトのメイン Web サイトの URL。
        ProjectUri = 'https://github.com/mkht/DSCR_AutoLogon'

        # このモジュールを表すアイコンの URL。
        # IconUri = ''

        # このモジュールの ReleaseNotes
        # ReleaseNotes = ''

    } # PSData ハッシュテーブル終了

} # PrivateData ハッシュテーブル終了

# このモジュールの HelpInfo URI
# HelpInfoURI = ''

# このモジュールからエクスポートされたコマンドの既定のプレフィックス。既定のプレフィックスをオーバーライドする場合は、Import-Module -Prefix を使用します。
# DefaultCommandPrefix = ''

}

