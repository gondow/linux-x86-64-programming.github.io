<style type="text/css">
body { counter-reset: chapter 1; }
</style>

# 前書き

## 言い訳

本書はまだ執筆途中です．不完全な部分があることをお許しください．
<!-- (書き進めることを優先して，内容のチェックが不十分です)． -->
しかしながら，誤りの指摘や改善のためのコメントは歓迎いたします．
本書のGithubリポジトリは[こちら](https://github.com/gondow/linux-x86-64-programming)です．

## 本書の目的

本書は筆者（権藤克彦）が[東京工業大学](https://www.titech.ac.jp/)の
[情報工学系](https://educ.titech.ac.jp/cs/)で
長年担当したアセンブリ言語の授業の資料をオンライン資料として
まとめ直したものです．
Intel x86-64，Linux，GNUアセンブラを前提として「アセンブリ言語とは何か」
「具体的にどうプログラミングすればいいのか」を分かりやすくお伝えすることが目的です．

ただし，本書では以下は扱っていません．

- 浮動小数点命令
- (デバイスドライバの実装に必要な)I/O命令
- (OSの実装に必要な)特権命令
- MMX/SSE/AVXなどの拡張命令

いや，書いてもいいのですが分量が膨大になるので面倒くさいんです．
もしOS自作に興味があるなら書籍[ゼロからのOS自作入門](https://www.amazon.co.jp/dp/4839975868/)を強くお勧めします．

## 本書で使う環境

本書では以下の環境を使用しています．皆さんの環境がLinuxであれば多少違っても大丈夫なはずです．

- Ubuntu 22.04 LTS (OS)
- GNU gcc-11.3.0 (コンパイラ)
- GNU binutils-2.38 (バイナリ・ユーティリティ，GNUアセンブラ`as`を含む)
- GNU gdb-12.1 (デバッガ)

デバッガはアセンブリ言語の実行結果を確認するために便利ですので，ぜひ準備して下さい．

しかし，WindowsやmacOSの場合は，本書の内容と大きく異なってしまいます．
アセンブリ言語は環境への依存度が高く，そのため移植性がとても低いからです．

皆さんのパソコンがWindowsやmacOSだった場合，Linux環境を導入する方法として以下のようないろいろな方法があります．筆者のお勧めは
- WindowsならWSL2を使う
- Intel Macなら仮想マシンVirtualBoxをインストールして，Ubuntu Desktopをインストールする
  ([Apple Silicon Mac用のVirtualBox](https://isapplesiliconready.com/jp/app/Virtualbox)は2023/12/6時点でベータ版です)
- Apple Silicon Macなら仮想マシンUTM/QEMUをインストールして，
  **(仮想化ではなく)エミュレート**で[Ubuntu Server](https://jp.ubuntu.com/download/thank-you?version=22.04.4&architecture=amd64&platform=live-server)をインストールする

です．

Linux環境を導入する方法：
- [WSL2](https://learn.microsoft.com/ja-jp/windows/wsl/install) (Windows Subsystem for Linux 2)を使えるように設定する．
- [VirtualBox](https://www.virtualbox.org/)や
  [VMWare Fusion](https://www.vmware.com/jp/products/fusion.html)
などの仮想マシンをインストールして，その仮想マシン上に[Ubuntu](https://www.ubuntulinux.jp/home)などのLinuxをインストールする．
   Apple Silicon Mac上では，Intel Linuxのイメージは動作不可(2024/3現在)．
- [UTM/QEMU](https://mac.getutm.app/)の仮想マシンに，
  **（仮想化ではなく）エミュレート**で[Ubuntu Server](https://jp.ubuntu.com/download/thank-you?version=22.04.4&architecture=amd64&platform=live-server)などのLinuxをインストールする．
  動作が遅いので，Ubuntu Desktop ではなく Ubuntu Server が良いです．
  Ubuntu Serverのコンソールではコピペもできないので，sshでホストマシンからログインできるようにすると便利．
  Apple Silicon Mac上で，Intel Linuxのイメージが動作可能．
- [Docker](https://www.docker.com/)などのコンテナ実行環境をインストールして，その上で[Ubuntu](https://www.ubuntulinux.jp/home)などのLinuxをインストールする．既存のイメージを使っても良い．Apple Silicon Mac上のDockerで，Intel Linuxのイメージが動作可能です．
- オンライン環境（例えば[repl.it](https://replit.com/)）を使う．

Linux環境の導入方法を書くと切りが無いので，皆さん自身でググって下さい．

私が使った Ubuntu 22.04 LTSには`gcc`などが未インストールなので，
以下のコマンドでインストールしました．

```
$ sudo apt install build-essential
$ sudo apt install gdb
```

## 本書のライセンス

Copyright (C) 2023 Katsuhiko Gondow

本書は[クリエイティブ・コモンズ4.0表示(CC-BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/deed.ja)で提供します．

## 本書の作成・公開環境

- マークダウン環境 [mdbook](https://rust-lang.github.io/mdBook/)
- お絵かきツール [draw.io](https://www.drawio.com/)
- 公開環境 [Github Pages](https://docs.github.com/ja/pages/getting-started-with-github-pages/about-github-pages)


## 本書のお約束

### メモリの図では0番地が常に上

本書ではメモリの図を書く時，必ず0番地(低位アドレス)が上，
高位アドレスが下になるようにします．

<img src="figs/oyakusoku-memory.svg" height="150px" id="fig:oyakusoku-memory">

その結果，本書の図では「スタックは上に成長」，「ヒープは下に成長」することになります
([メモリレイアウト](2-asm-intro.md#fig:memory-layout))．

### ❶❷などの黒丸数字は説明用

実行結果中の❶や❷などの黒丸数字は，説明のために私が追加したものです．
実行結果の出力ではありません．
例えば，以下が例で，`file`コマンドの出力例です．
本文中の説明と実行結果のどこが対応しているのかを明示するために使います．

```
$ file add5.o
add5.o: ❶ELF 64-bit ❷LSB ❸relocatable, x86-64, ❹version 1 (SYSV), ❺not stripped
```

[Practical Binary Analysis](https://practicalbinaryanalysis.com/)
という書籍がこうしていて便利なので真似させてもらっています．

### 一部を隠してます．

「細かい説明」「演習問題の答え」などは`details`タグを使って隠しています．
最初は読み飛ばして構いません．読む場合は▶ボタンを押して下さい．

<details>
<summary>
←このボタン(またはこの行)を押してみて下さい
</summary>

これが隠されていた内容です．
</details>

### 一部の図はタブ表示にしています

一部の図はタブ切り替えでパラパラ漫画のように表示しています．
一度に全部を表示するとゴチャゴチャする場合などに使います．
以下はタブ表示の例です．

<form class="tab-wrap">
    <input id="tail-call-opt1" type="radio" name="TAB" class="tab-switch" checked="checked" />
    <label class="tab-label" for="tail-call-opt1">末尾コール最適化の前</label>
    <div class="tab-content">
    	 <img src="figs/tail-call-opt1.svg" height="100px" id="fig:tail-call1-opt">
    </div>
    <input id="tail-call-opt2" type="radio" name="TAB" class="tab-switch" />
    <label class="tab-label" for="tail-call-opt2">末尾コール最適化後</label>
    <div class="tab-content">
    	 <img src="figs/tail-call-opt2.svg" height="93px" id="fig:tail-call-opt2">
    </div>
</form>

### [サンプルコード](https://github.com/gondow/linux-x86-64-programming/tree/main/docs/asm)があります
[サンプルコード](https://github.com/gondow/linux-x86-64-programming/tree/main/docs/asm)
には2種類のファイルがあります．

- `*.s` アセンブリコード
- `*.txt` `gdb`のコマンド列が書かれたファイル

これらのファイルとデバッガ`gdb`を使って機械語命令を実行・確認する方法は，
[こちら](./6-inst.md#how-to-execute-x86-inst)に説明があります．
(サンプルコードの準備，めっちゃ大変だったので活用して頂けるととても嬉しいです)．

### (説明せず)擬似コードを使っている部分があります

例えば，[`mov`命令の説明](./x86-list.md#mov-plain)では
`movq %rax, %rbx`の動作の説明として，`%rbx = %rax`と書いています．
`%rbx = %rax`はアセンブリ言語でも無くC言語でも無い，
C言語風の**擬似コード**(psuedo code)です．
「`%rax`レジスタの値を`%rbx`レジスタに格納する」という動作を
簡潔に表現する手段として使わせて下さい．

## 本書のお断り

### 2023/10/5現在，[日本語検索](https://github.com/rust-lang/mdBook/issues/2052)に対応しました．

### 「ですます」調と「だである」調がまざってる

すみません，自覚してますがとりあえず放置です．
後で統一するかも知れませんし，しないかも知れません．

### サンプルコードのインデントがおかしい

すみません，インデントしたコードブロック中でmdbookの#include機能を使うと
表示が狂ってしまうため，意図的にインデントしていない箇所が多々あります．

## Todo

- Intel CET対応のtigerlakeでサンプルコードを試していない．

  デフォルトのビルドで(endbr64が無い)サンプルコードがこけるとまずい
  **どなたか tigerlakeのパソコンを貸して下さい😁**
