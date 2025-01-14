<style type="text/css">
body { counter-reset: chapter 3; }
</style>

# バイナリファイル

## バイナリファイルの中身を見る

### 16進ダンプ{#hexdump}
`add5.c`や`add5.s`はテキストファイルですが，
[2節のアセンブリ言語](./2-asm-intro.md#アセンブル)で作成した
`add5.o`はバイナリファイルです．
バイナリファイルなので，`less`コマンドでは中身を読めません．

```bash
$ less add5.o
^?❶ELF^B^A^A^@^@^@^@^@^@^@^@^@^A^@>^@^A^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@X^B
^@^@^@^@^@^@^@^@^@^@@^@^@^@^@^@@^@^L^@^K^@<F3>^O^^<FA>UH<89><E5><89>}<FC><8B>E
（長いので省略）
```

<details id="ELF">
<summary>
❶ELFとは
</summary>

上の`less`コマンドの結果にELFという文字が見える理由を説明します．
ELFはLinuxが採用している**バイナリ形式**(binary format)です．
このELFのバイナリファイルの先頭4バイトには**マジックナンバー**という
バイナリファイルを識別する特別な数値が入っています．
ELFバイナリのマジックナンバーは `7F 45 4C 46`です．
`45 4C 46`はASCII文字で `E L F` なので，lessコマンドが`ELF`と表示したわけです． 
</details>

バイナリファイルの中身を読むには例えば`od`コマンドを使います．

```bash
$ od -t x1 add5.o
0000000 7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
0000020 01 00 3e 00 01 00 00 00 00 00 00 00 00 00 00 00
（長いので省略）
```

一番左の数字が「先頭からのバイト数(16進表記)」，
その右側に並んでいるのが「1バイトごとに16進表記したファイルの中身」です．
（1バイトのデータは2桁の16進数で表せることを思い出しましょう．
例えば，`add5.o`の中身の先頭4バイトの値は`7F 45 4C 46`です）．

`-t x1`というオプションは「1バイトごとに16進数で表示せよ」という意味です．
このような出力を**16進ダンプ**(hex dump)と言います．
他に16進ダンプするコマンドとして，`xxd`や`hexdump`などがあります．

ちなみに，`add5.c`はテキストファイルですが，内容は2進数で保存されて
いますので，`od`コマンドで中身を表示できます．

```bash
$ od -t x1 add5.c
0000000 69 6e 74 20 61 64 64 35 20 28 69 6e 74 20 6e 29
0000020 0a 7b 0a 20 20 20 20 72 65 74 75 72 6e 20 6e 20
0000040 2b 20 35 3b 0a 7d 0a
0000047
```

先頭の`69`はASCII文字`i`の文字コード，
同様に，次の`6e`は文字`n`，その次の`74`は文字`t`なので，
`add5.c`の先頭3文字が`int`であることを確認できます．
[ASCIIコード](./4-data.md#ASCII)表は`man ascii`コマンドで閲覧できます．
（例えば，16進数の`0x69`は10進数の`105`です．
[ASCIIコード](./4-data.md#ASCII)表の`105`番目の文字は`i`です．）


<details>
<summary>
manコマンドとは
</summary>

 `man`コマンドはLinux上でマニュアルを表示するコマンドです．
 
例えば`man ascii`を実行すると以下のように表示されます．

```bash
$ man ascii

ASCII(7)                   Linux Programmer's Manual                  ASCII(7)

NAME
       ascii - ASCII character set encoded in octal， decimal， and hexadecimal

DESCRIPTION
       ASCII is the American Standard Code for Information Interchange.  It is
       a 7-bit code.  Many 8-bit codes (e.g.， ISO  8859-1)  contain  ASCII  as
       their  lower  half.  The international counterpart of ASCII is known as
       ISO 646-IRV.

       The following table contains the 128 ASCII characters.

       C program '\X' escapes are noted.

       Oct   Dec   Hex   Char                        Oct   Dec   Hex   Char
       ────────────────────────────────────────────────────────────────────────
       000   0     00    NUL '\0' (null character)   100   64    40    @
       001   1     01    SOH (start of heading)      101   65    41    A
       002   2     02    STX (start of text)         102   66    42    B
（以下略）
```

デフォルトでは`less`コマンドで1ページずつ表示されるので，
スペースキーで次のページが，`b`を押せば前のページが表示されます．
終了するには`q`を押します．`h`を押せばヘルプを表示し，`/`で検索もできます．
例えば，`/backspace`と入力してリターンを押すと，`backspace`を検索してくれます．

`man`コマンドは章ごとに分かれています．例えば
- 1章はコマンド (例：`ls`)
- 2章はシステムコール (例：`open`)
- 3章はライブラリ関数 (例：`printf`)

となっています．
`printf`というコマンドがあるので，
`man printf`とすると（ライブラリ関数ではなく）コマンドの`printf`の
マニュアルが表示されてしまいます．
ライブラリ関数の`printf`を見たい場合は
`man 3 printf`と章番号も指定します．
</details>

なお，`od`コマンドに`-c`オプションをつけると，
(文字として表示可能なバイトは)文字が表示されます．

```bash
$ od -t x1 -c add5.c
0000000  69  6e  74  20  61  64  64  35  20  28  69  6e  74  20  6e  29
          i   n   t       a   d   d   5       (   i   n   t       n   )
0000020  0a  7b  0a  20  20  20  20  72  65  74  75  72  6e  20  6e  20
         \n   {  \n                   r   e   t   u   r   n       n    
0000040  2b  20  35  3b  0a  7d  0a
          +       5   ;  \n   }  \n
0000047
```

### コンピュータの中のデータはすべて`0`と`1`から成る{#everything-binary}

ここで大事なことを復習しましょう．
それは
**「コンピュータの中のデータは，どんな種類のデータであっても，
機械語命令であっても，すべて`0`と`1`だけで表現されている」**
ということです．
ですので，テキストはバイナリでもあるのです．
- テキスト=文字として表示可能な2進数だけを含むデータ
- バイナリ=文字以外の2進数も含んだデータ

<img src="figs/text-binary.svg" height="100px" id="fig:text-binary">

> 注意：
> 本書で，テキスト(text)という言葉には2種類の意味があることに注意して下さい．
> - 1つは「文字」を意味します．例：「テキストファイル」（文字が入ったファイル）
> - もう1つは「機械語命令列」を意味します．例：「[テキストセクション](#.text)」（機械語命令列が格納されるセクション）

### 2進数と符号化

[前節](#everything-binary)で説明した通り，
コンピュータ中では全てのものを0と1の2進数で表現する必要があります．
そのため，データの種類ごとに2進数での表現方法，つまり**符号化**
(encoding)の方法が定められています．
例えば，
- 文字`U`をASCII文字として符号化すると，`01010101`になります．
- `pushq %rbp`をx86-64の機械語命令として符号化すると，`01010101`になります．

おや，どちらも同じ`01010101`になってしまいました．
この2進数が`U`なのか`pushq %rbp`なのか，どうやって区別すればいいでしょう？
答えは「これだけでは区別できません」です．

<img src="figs/encode.svg" height="130px" id="fig:encode">

別の手段（情報）を使って，いま自分が注目しているデータが，
文字なのか機械語命令なのかを知る必要があります．
例えば，この後で説明する[`.text`セクション](#.text)にある
2進数のデータ列は「`.text`セクションに存在するから」という理由で
機械語命令として解釈されます．

### `file`コマンド

[16進ダンプ](#hexdump)以外の方法で，`add5.o`の中身を見てみます．
まずは`file`コマンドです．
`file`コマンドはファイルの種類の情報を教えてくれます．

```bash
$ file add5.o
add5.o: ❶ELF 64-bit ❷LSB ❸relocatable， x86-64， ❹version 1 (SYSV)， ❺not stripped
```

これで，`add5.o`が64ビットの❶ELFバイナリであることが分かりました．
ELFはバイナリ形式(バイナリを格納するためのファイルフォーマット)の1つです．
Linuxを含めて多くのOSがELFをバイナリ形式として使っています．

<details id="LSB">
<summary>
❷LSBとは
</summary>

 多バイト長のデータをバイト単位で格納する順序を**バイトオーダ**(byte order)といいます．
 LSBは最下位バイトから順に格納するバイトオーダ (Least Significant Byte first)，
 つまり[リトルエンディアン](4-data.md#バイトオーダとエンディアン)
 を意味しています．
 
 x86-64のバイトオーダがリトルエンディアンのため，
 このELFバイナリもリトルエンディアンになっています．
 ELFバイナリがビッグエンディアンかリトルエンディアンかどうかを示すデータが，
 ELFバイナリのヘッダに格納されています．
 これは`readelf -h`コマンドで調べられます❶．

```
$ readelf -h a.out
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:        ELF64
  Data:         2's complement, ❶little endian
  Version:      1 (current)
  OS/ABI:       UNIX - System V
(以下略)
```
 
 リトルエンディアンでの注意は16進ダンプする時に，多バイト長データが逆順に表示されることです．
 以下で多バイト長データ❶`0x11223344`を`.text`セクションに配置してアセンブルした
 `little.o`を逆アセンブルすると，❸`44 33 22 11`と逆順に表示されています．
 (`objdump -h`の出力から，`.text`セクションのオフセット(ファイルの先頭からのバイト数)が❷0x40バイトであることを使って，`od`コマンドに`-j0x40`オプションを使い，`.text`セクションの先頭付近の情報を表示しています)

 ```bash
 $ cat little.s
 .text
 ❶.long 0x11223344
 $ gcc -c little.s
 $ objdump -h little.o
 foo.o:     file format elf64-x86-64
 Sections:
 Idx Name          Size      VMA               LMA               File off  Algn
   0 .text         00000004  0000000000000000  0000000000000000 ❷00000040  2**0
                   CONTENTS， ALLOC， LOAD， READONLY， CODE
   1 .data         00000000  0000000000000000  0000000000000000  00000044  2**0
                   CONTENTS， ALLOC， LOAD， DATA
   2 .bss          00000000  0000000000000000  0000000000000000  00000044  2**0
                   ALLOC
 $ od -t x1 -j0x40 little.o | head -n1
 0000100 ❸44 33 22 11 00 00 00 00 00 00 00 00 00 00 00 00
 ```
</details>

<!--
これは嘘でしたｗ
LSBはLinuxの標準である[Linux Standard Base](https://refspecs.linuxfoundation.org/lsb.shtml)の略です．LSBはELFバイナリの規格であるSystem V ABIを含んでいます．
ABIはapplication binary interfaceの略です．
-->

<details>
<summary>
❸relocatableとは
</summary>

バイナリ中のアドレスを再配置 (relocate)できるバイナリのことを
再配置可能 (relocatable)であるといいます．オブジェクトファイルはリンク時や実行時にアドレスを変更できるよう，
relocatableであることが多いです．
</details>

<details>
<summary>
❹version 1 (SYSV)とは
</summary>

LinuxのABI（バイナリ互換規約）である[System V ABI](https://wiki.osdev.org/System_V_ABI)
に準拠していることを表しています．
</details>

<details>
<summary>
❺not strippedとは
</summary>

バイナリには実行に直接関係ない**記号表**や**デバッグ情報**などが
含まれていることがよくあります．
この「実行に直接関係ない情報」が削除されたバイナリのことを
stripped binaryと呼びます．
`strip`コマンドで「実行に直接関係ない情報」を削除できます．
削除された分，サイズが少し減っています．

```bash
$ ls -l add5.o
-rw-rw-r-- 1 gondow gondow 1368 Jul 19 10:09 add5.o
$ strip add5.o
$ ls -l add5.o
-rw-rw-r-- 1 gondow gondow 880 Jul 19 14:58 add5.o
```
</details>

<details>
<summary>
.textセクションだけ抜き出す
</summary>

GNU binutilsの`objcopy`コマンドを使うと，特定のセクションだけ抜き出せます．
以下では`little.o`から`.text`セクションを抜き出して，ファイル`foo`に書き込んでいます．

```
$ objcopy --dump-section .text=foo little.o
$ od -t x1 foo
0000000 44 33 22 11
0000004
```

`objcopy`はセクションの注入も可能です．
以下ではファイル`foo`の内容を`little.o`の新しいセクション`.text2`として注入しています．
新しいセクション❶`.text2`が出来ていることが分かります．

```
$ objcopy --add-section .text2=foo --set-section-flags .hoge=noload,readonly little.o
$ objdump -h little.o
little.o:     file format elf64-x86-64
Sections:
Idx Name       Size      VMA               LMA               File off  Algn
  0 .text      00000004  0000000000000000  0000000000000000  00000040  2**0
               CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data      00000000  0000000000000000  0000000000000000  00000044  2**0
               CONTENTS, ALLOC, LOAD, DATA
  2 .bss       00000000  0000000000000000  0000000000000000  00000044  2**0
               ALLOC
  3 ❶.text2     00000004  0000000000000000  0000000000000000  00000044  2**0
               CONTENTS, READONLY
```

</details>

なお，`file`コマンドはバイナリ以外のファイルにも使えます．

```bash
$ file add5.c
add5.c: ASCII text
$ file add5.s
add5.s: assembler source， ASCII text
$ file .
.:  directory
$ file /dev/null
/dev/null: character special (1/3)
```

### セクションと`objdump -h`コマンド{#.text}


バイナリファイルの構造はざっくり以下の図のようになっています．

<img src="figs/section.svg" height="250px" id="fig:text-binary">

- 最初のヘッダ以外の四角を**セクション**(section)と呼びます．
- バイナリはセクションという単位で区切られていて，それぞれ別の目的でデータが格納されます．
- ヘッダは目次の役割で「どこにどんなセクションがあるか」という情報を保持しています．

ヘッダの情報は`objdump -h`で表示できます．

```bash
$ objdump -h add5.o
add5.o:     file format elf64-x86-64
Sections:
Idx Name     Size      VMA               LMA               File off  Algn
  0 .text    00000013  0000000000000000  0000000000000000  00000040  2**0
             CONTENTS， ALLOC， LOAD， READONLY， CODE
  1 .data    00000000  0000000000000000  0000000000000000  00000053  2**0
             CONTENTS， ALLOC， LOAD， DATA
  2 .bss     00000000  0000000000000000  0000000000000000  00000053  2**0
             ALLOC
(以下略)
```

ここでは「`.text`，`.data`，`.bss`という3つのセクションがある」ことを
見ればOKです．


<details>
<summary>
VMAとLMAとは
</summary>

VMAはvirtual memory addressの略で「メモリ上で実行される時の
このセクションのメモリアドレス」です．
一方，LMAはload memory addressの略で「メモリ上にロード(コピー，配置)する時の
このセクションのメモリアドレス」です．
通常，セクションをメモリにロードした後で，移動せずにそのまま実行するため，VMAとLMAは同じアドレスになります．
`add5.o`ではアドレスが決まってないので，VMAもLMAもゼロになっています．
</details>

<details>
<summary>
File offとは
</summary>

File offはファイルオフセットを表しています．このセクションがバイナリファイルの先頭から何バイト目から始まっているかを16進表記で表しています．
</details>

<details>
<summary>
Algnとは
</summary>

Algnは**アラインメント**(alignment)を表しています．
例えば「このセクションをメモリ上に配置する時，その先頭アドレスが8の倍数になるようにしてほしい」という状況の時，この部分が`2**3`となります（2の3乗=8）．
</details>

<details>
<summary>
CONTENTS， ALLOC， LOAD， READONLY， CODEとは
</summary>

これらはセクションフラグと呼ばれるセクションの属性値です．

- CONTENTS  このセクションには中身がある (例えば，`.bss`はCONTENTSが無いので(ファイル中では)中身が空のセクションです)
- ALLOC     ロード時にこのセクションのためにメモリを割り当てる必要がある
- LOAD      このセクションは実行するためにメモリ上にロードする必要がある
- READONLY  メモリ上では「読み込みのみ許可（書き込み禁止）」と設定する必要がある
- CODE      このセクションは実行可能な機械語命令を含んでいる
</details>


<br/>
<div id=".bss">

3つのセクション `.text` ，`.data`，`.bss` の役割は以下の通りです：

- `.text`セクションは機械語命令を格納します．例えば，`pushq %rbp`を表す`0x55`は`.text`セクションに格納されます．
- `.data`セクションは初期化済みの静的変数の値を格納します．例えば，大域変数`int x=999;`があったとき，999の2進数表現が`.data`セクションに格納されます．
- `.bss`セクションは未初期化の静的変数の値を格納します．例えば，大域変数`int y;`があったとき，（概念的には）初期値0の2進数表現が`.bss`セクションに格納されます．
</div>

<details>
<summary>
なぜ概念的
</summary>

実はファイル中では`.bss`セクションにはサイズ情報などごくわずかの情報しか持っていません．実行時にメモリ上に`.bss`セクションを作る際に，実際に必要なメモリを確保して，そのメモリ領域をすべてゼロで初期化すれば十分だからです（ファイル中に大量のゼロの並びを保持する必要はありません）．

```
{{#include asm/bss.c}}
```

例えば，`bss.c`の`int a[1024];` の変数`a`は未初期化なので，
変数`a`の実体は`.bss`セクションに置かれます．アセンブリコードを見てみると，

```
$ gcc -S bss.c
$ cat bss.s
(関係する箇所以外は削除)
 ❶ .bss                # 以下を.bssセクションに出力
    .align 32           # 次の出力アドレスを32の倍数にせよ
    .type   a, @object  # ラベルaの型はオブジェクト(関数ではなくデータ)
    .size   a, 4096     # ラベルaのサイズは4096バイト
a:                      # ラベルaの定義
 ❷ .zero   4096        # 4096バイト分のゼロを出力せよ
```

❶`.bss`セクションに❷4096バイト分のゼロを出力するように見えますが，
ヘッダを見てみると，ファイル中の`.bss`セクションの中身は0バイトだと分かります．


```
$ gcc -g bss.c
$ objdump -h ./a.out
Sections:
Idx Name          Size      VMA               LMA                File off  Algn
(中略)
23 ❸.bss     ❹ 00001020  0000000000004020  0000000000004020 ❺ 00003010  2**5
                ❼ALLOC
24   .comment    0000002b  0000000000000000  0000000000000000 ❻ 00003010  2**0
                  CONTENTS, READONLY
```

❸`.bss`セクションのサイズは16進数で❹ 0x1020バイト(10進数では4128バイト)ですが，
ファイルオフセットを比較してみると，❺と❻が同じ値(`000033010`)なので，
ファイル中での`.bss`セクションのサイズは0バイトだと分かります．
また，セクション属性が❼`ALLOC`のみで，
`CONTENTS`(中身がある)が無いことからも0バイトと分かります．
</details>

さらに代表的なセクションである`.rodata`も説明します．
- `.rodata`セクションは読み込みのみ(read-only)なデータの値を格納します．例えば，C言語の文字列定数`"hello"`は書き込み禁止なので，`"hello"`の2進数表現が`.rodata`セクションに格納されます．

バイナリファイルには上記以外のセクションも数多く使われますが，
まずはこの基本の4種類 (`.text`， `.data`， `.bss`， `.rodata`) を覚えましょう．

### 記号表の中身を表示させる(`nm`コマンド){#nm}

バイナリファイル中には**記号表**(symbol table)があることが多いです．
記号表とは「変数名や関数名がバイナリ中では何番地のアドレスになっているか」という情報です．
`nm`コマンドでバイナリファイル中の記号表を表示できます．
まず，以下の`foo.c`を準備して下さい．

```
// foo.c
int g1 = 999;
int g2;
int s1 = 888;
int s2;
int main ()
{
    static int s3 = 777;
    static int s4;
    int ❼i1 = 666;
    int ❼i2;
}
```

そしてコンパイルして，`nm`コマンドで記号表の中身を表示させます．

```bash
$ gcc -c foo.c
$ nm foo.o
0000000000000000 ❶D g1
0000000000000000 ❸B g2
0000000000000000 ❺T main
0000000000000004 ❶D s1
0000000000000004 ❸B s2
0000000000000008 ❷d ❻s3.0
0000000000000008 ❹b ❻s4.1
```

この出力の読み方は以下の通りです．
- ❶`D`と❷`d`は`.data`セクションのシンボル，❸`B`と❹`b`は`.bss`セクションのシンボル，❺`T`と`t`は`.text`セクションのシンボルであることを表す
- 大文字はグローバル（ファイルをまたがって有効なシンボル），小文字はファイルローカルなシンボルであることを表す
- `static`付きの局所変数を表すシンボルは
  他の関数中の同名のシンボルと区別するために，
  ❻`.0`や`.1`などが付加されることがある．
- 左側の`00`，`04`，`08`がシンボルに対応するアドレスですが，再配置前(relocation前)なので仮のアドレス(各セクションの先頭からのオフセット)
- (`static`のついてない)局所変数❼は記号表には含まれていない．
  局所変数(自動変数)は実行時にスタック上に実体が確保されます．

### ASLRとPIE（ちょっと脱線）{#ASLR-PIE}

オブジェクトファイルのセクションごとの仮のアドレスは，
リンク後の`a.out`では具体的なアドレスになります

```bash
$ gcc foo.c
$ nm ./a.out | egrep g1
0000000000004010 D g1
$ nm ./a.out | egrep main
                 U __libc_start_main@@GLIBC_2.34
0000000000001129 T main
```

<details>
<summary>
U __libc_start_main@@GLIBC_2.34とは
</summary>

バイナリ中で参照されているけど定義がないシンボルがあると，
`nm`コマンドはundefinedを意味する`U`を表示します．
実は`a.out`は`main`関数を呼び出す前に`__libc_start_main`という
GLIBC中の関数を([動的リンク](#動的リンク)した上で)呼び出します．
`__libc_start_main`は
様々な初期化を行った後，(その名の通り)`main`関数を呼び出すのが主な役割です．

ちなみに`__libc_start_main`は`_start`が呼び出します．

```
$ readelf -h ./a.out | egrep Entry
  Entry point address:           ❶ 0x1040
$ objdump -d ./a.out | egrep 1040
0000000000001040 ❷ <_start>:
    1040:	f3 0f 1e fa          	endbr64 
```

`a.out`の**エントリポイント**(最初に実行するアドレス)は
❶ `0x1040`番地です．この番地には❷`_start`があるので，
`a.out`を実行すると最初に実行される関数は`_start`と分かります．
</details>

出力が長くなるので，`g1`と`main`のアドレスだけ載せています．
`g1`のアドレスは`0x4010`番地，`main`のアドレスは`0x1129`番地となりました．
ただし，このまま実行すると，`g1`や`main`のアドレスはこれらのアドレスにはならず，
実行するたびに変わります．
これは**ASLR**や**PIE**というセキュリティ対策機能のためです．

確かめてみましょう．
以下の`foo2.c`を普通にコンパイルして実行してみます．

```C
// foo2.c
#include <stdio.h>
int g1 = 999;
int main ()
{
    printf ("%p, %p\n", &g1, main);
}
```

以下の通り，`g1`や`main`のアドレスは実行するたびに変わりますし，
`nm`が出力したアドレスとも異なります．

```bash
$ gcc foo2.c
$ ./a.out
0x557f2361e010， 0x557f2361b149
$ ./a.out
0x55a40e6f5010， 0x55a40e6f2149
$ ./a.out
0x562750663010， 0x562750660149
$ 
```

ここではASLRとPIEの機能を無効にして，アドレスが変わらなくなることを確認します．

```bash
$ sudo sysctl -w kernel.randomize_va_space=0  # ASLRをオフ
$ gcc -no-pie foo2.c                          # PIEをオフ
$ nm ./a.out | egrep main
                 U __libc_start_main@@GLIBC_2.34
0000000000401136 T main
$ nm ./a.out | egrep g1
0000000000404030 D g1
$ ./a.out
&g1=0x404030， main=0x401136
$ ./a.out
&g1=0x404030， main=0x401136
$ ./a.out
&g1=0x404030， main=0x401136
```

ASLRとPIEの機能をオフにすることで，アドレスが変わらなくなり，
かつ`nm`が出力するアドレスと同じになることが確認できました．

> 注意：
> 不用意なASLRとPIEの無効化はセキュリティ機能を下げるので避けるべきです．
> しかしデバッグ作業ではアドレスが変わらなくなるので
> ASLRとPIEの無効化が有用な場合もあります．
> なお，デバッガ中ではASLRは無効化されていることが多いです．


<details>
<summary>
ASLRとは
</summary>

ASLR (address space layout randomizationの略)は，
アドレス空間の配置をランダム化する機能です．
テキスト（実行コード），ライブラリ，スタック，ヒープなどをメモリ上に
配置するアドレスを実行するたびにランダムに変化させます．
以下を実行するとASLRは無効化され，

```bash
$ sudo sysctl -w kernel.randomize_va_space=0
```

以下を実行するとASLRは有効化されます．

```bash
$ sudo sysctl -w kernel.randomize_va_space=1
```
</details>

<details id="PIE">
<summary>
PIEとは
</summary>

PIE (position independent executableの略)は位置独立実行可能ファイルを意味します．
通常，動的ライブラリは位置独立コードPIC (position independent code)としてコンパイルされます．
動的ライブラリはメモリ上で共有されるため，どのアドレスに配置してもそのまま再配置せずに，実行したいからです．
PIEは動的ライブラリだけでなく，`a.out`も位置独立にした実行可能ファイルを指します．
`-no-pie`オプションでコンパイルすると，PIEを無効化できます．

```bash
$ gcc -no-pie foo2.c
```
</details>

## 逆アセンブル再び{#逆アセンブル再び}

[逆アセンブル](./2-asm-intro.md#逆アセンブル)で説明した通り，
`objdump -d ./a.out`で逆アセンブル結果が表示されます（再掲）．

```bash
$ objdump -d add5.o
add5.o:     file format elf64-x86-64
Disassembly of section .text:
0000000000000000 <add5>:
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	48 89 e5             	mov    %rsp，%rbp
   8:	89 7d fc             	mov    %edi，-0x4(%rbp)
   b:	8b 45 fc             	mov    -0x4(%rbp)，%eax
   e:	83 c0 05             	add    $0x5，%eax
  11:	5d                   	pop    %rbp
  12:	c3                   	retq   
```

`objdump`コマンドは`add5.o`の`.text`セクションを抽出し，
そのデータを機械語命令として解釈して，対応するニモニックを出力しています．

この出力によれば，`.text`セクションの先頭4バイトは`F3 0F 1E FA`で，
この4バイトが`endbr64`命令になります
（x86-64の命令長は可変長で，1バイト〜15バイトです）．

以下では`.text`セクションの先頭4バイトが`F3 0F 1E FA`であることを確認します．

セクションのヘッダを出力するコマンド[`objdump -h`](#.text)の出力を再掲します．

```bash
$ objdump -h add5.o
add5.o:     file format elf64-x86-64
Sections:
Idx Name     Size      VMA               LMA                File off  Algn
  0 .text    00000013  0000000000000000  0000000000000000 ❶00000040  2**0
             CONTENTS， ALLOC， LOAD， READONLY， CODE
  1 .data    00000000  0000000000000000  0000000000000000   00000053  2**0
             CONTENTS， ALLOC， LOAD， DATA
  2 .bss     00000000  0000000000000000  0000000000000000   00000053  2**0
             ALLOC
```

`.text`セクションの`File off`の欄を見ると❶`00000040`とあります．
これは`.text`セクションが`add5.o`の先頭から16進数で40バイト
目(以後，0x40と表記)にあることを意味しています．

`od`コマンドの`-j`オプションを使うと，指定したバイト数だけ，
先頭をスキップしてくれます．
この`-j`オプションを使って，0x40バイトスキップして，
`.text`セクションの最初だけを16進ダンプします
（`head -n3`は先頭の3行だけ表示します）．

```bash
$ od -t x1 -j0x40 add5.o | head -n3
0000100 ❶f3 0f 1e fa 55 48 89 e5 89 7d fc 8b 45 fc 83 c0
0000120   05 5d c3 00 47 43 43 3a 20 28 55 62 75 6e 74 75
0000140   20 39 2e 34 2e 30 2d 31 75 62 75 6e 74 75 31 7e
```

この結果❶を見ると，`.text`セクションの最初の4バイトは
`F3 0F 1E FA`であることが分かります．
これは上の[逆アセンブルの結果](#逆アセンブル再び)の先頭4バイトと一致しており，
`endbr64`命令が，`add5.o`の先頭から0x40バイト目に存在することが分かりました．

## 広義のコンパイルとリンク{#広義のコンパイル}

ここでは広義のコンパイル，つまりCのプログラム`foo.c`から
実行可能ファイル`a.out`を生成する処理の中身を見ていきます．
いちばん大事なのは最後の**リンク**(link)です．

<img src="figs/compile-all.svg" height="300px" id="fig:compile-all">

- ❶ Cの前処理，すなわち`#include`や`#define`などの前処理命令の処理と，マクロ（例えば`<stdio.h>`が定義する`NULL`や`EOF`）の展開を行います．`gcc -E`コマンドで実行できますが，内部的にはカッコ内の`cpp`や`cc1`コマンドが実行されています（現在は`cc1`）．
- ❷ 狭義のコンパイル処理で，Cのプログラムをアセンブリコードに変換します．
- ❸ アセンブラ(`as`コマンド)によるアセンブル処理で，オブジェクトファイル`foo.o`を生成します．`foo.o`中にはバイナリの機械語命令が入っています．
- ❹ `foo.o`だけでは実行可能ファイルは作れません．例えば，`printf`などのライブラリ関数の実体は，
`libc.a`([静的ライブラリ](#静的ライブラリ))や`libc.so`([動的ライブラリ](#動的ライブラリ))の中にあるからです．
また，`main`関数を呼び出すためのCスタートアップルーチン(多くの場合，`crt*.o`というファイル名)も必要です．
また，分割コンパイルの機能を使った結果，`foo.o`は他のC言語のプログラムをアセンブルしたオブジェクトファイル`*.o`が必要なことがよくあります．
「このような他のバイナリと`foo.o`を合体させて`a.out`を生成する処理」のことを**リンク**(link)と呼びます．


広義のコンパイルで具体的にどのような処理が行われてるのかを見るには，
`-v`をつけて`gcc -v`とコンパイルすれば表示されます．
（以下では表示を省略しています．全てを表示するには<i class="fa fa-eye"></i>ボタンを押して下さい）．

```bash
$ gcc -v main.c add5.s |& tee out
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/11/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none:amdgcn-amdhsa
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
~ Configured with: ../src/configure -v --with-pkgversion='Ubuntu 11.3.0-1ubuntu1~22.04.1' --with-bugurl=file:///usr/share/doc/gcc-11/README.Bugs --enable-languages=c，ada，c++，go，brig，d，fortran，objc，obj-c++，m2 --prefix=/usr --with-gcc-major-version-only --program-suffix=-11 --program-prefix=x86_64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-bootstrap --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-plugin --enable-default-pie --with-system-zlib --enable-libphobos-checking=release --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --disable-werror --enable-cet --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32，m64，mx32 --enable-multilib --with-tune=generic --enable-offload-targets=nvptx-none=/build/gcc-11-aYxV0E/gcc-11-11.3.0/debian/tmp-nvptx/usr，amdgcn-amdhsa=/build/gcc-11-aYxV0E/gcc-11-11.3.0/debian/tmp-gcn/usr --without-cuda-driver --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --with-build-config=bootstrap-lto-lean --enable-link-serialization=2
~ Thread model: posix
~ Supported LTO compression algorithms: zlib zstd
~ gcc version 11.3.0 (Ubuntu 11.3.0-1ubuntu1~22.04.1) 
~ COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'a-'
~  /usr/lib/gcc/x86_64-linux-gnu/11/cc1 -quiet -v -imultiarch x86_64-linux-gnu main.c -quiet -dumpdir a- -dumpbase main.c -dumpbase-ext .c -mtune=generic -march=x86-64 -version -fasynchronous-unwind-tables -fstack-protector-strong -Wformat -Wformat-security -fstack-clash-protection -fcf-protection -o /tmp/ccTw9Mym.s
~ GNU C17 (Ubuntu 11.3.0-1ubuntu1~22.04.1) version 11.3.0 (x86_64-linux-gnu)
~ 	compiled by GNU C version 11.3.0， GMP version 6.2.1， MPFR version 4.1.0， MPC version 1.2.1， isl version isl-0.24-GMP
~ 
~ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
~ ignoring nonexistent directory "/usr/local/include/x86_64-linux-gnu"
~ ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/11/include-fixed"
~ ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/11/../../../../x86_64-linux-gnu/include"
~ #include "..." search starts here:
~ #include <...> search starts here:
~  /usr/lib/gcc/x86_64-linux-gnu/11/include
~  /usr/local/include
~  /usr/include/x86_64-linux-gnu
~  /usr/include
~ End of search list.
~ GNU C17 (Ubuntu 11.3.0-1ubuntu1~22.04.1) version 11.3.0 (x86_64-linux-gnu)
~ 	compiled by GNU C version 11.3.0， GMP version 6.2.1， MPFR version 4.1.0， MPC version 1.2.1， isl version isl-0.24-GMP
~ 
~ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
~ Compiler executable checksum: e13e2dc98bfa673227c4000e476a9388
~ COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'a-'
~  as -v --64 -o /tmp/cc5o7Jgg.o /tmp/ccTw9Mym.s
~ GNU assembler version 2.38 (x86_64-linux-gnu) using BFD version (GNU Binutils for Ubuntu) 2.38
~ COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'a-'
~  as -v --64 -o /tmp/ccUs2R16.o add5.s
~ GNU assembler version 2.38 (x86_64-linux-gnu) using BFD version (GNU Binutils for Ubuntu) 2.38
~ COMPILER_PATH=/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/
~ LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/11/../../../../lib/:/lib/x86_64-linux-gnu/:/lib/../lib/:/usr/lib/x86_64-linux-gnu/:/usr/lib/../lib/:/usr/lib/gcc/x86_64-linux-gnu/11/../../../:/lib/:/usr/lib/
~ COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'a.'
~  /usr/lib/gcc/x86_64-linux-gnu/11/collect2 -plugin /usr/lib/gcc/x86_64-linux-gnu/11/liblto_plugin.so -plugin-opt=/usr/lib/gcc/x86_64-linux-gnu/11/lto-wrapper -plugin-opt=-fresolution=/tmp/ccgnuv0i.res -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s -plugin-opt=-pass-through=-lc -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s --build-id --eh-frame-hdr -m elf_x86_64 --hash-style=gnu --as-needed -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -z now -z relro /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/Scrt1.o /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/11/crtbeginS.o -L/usr/lib/gcc/x86_64-linux-gnu/11 -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../../lib -L/lib/x86_64-linux-gnu -L/lib/../lib -L/usr/lib/x86_64-linux-gnu -L/usr/lib/../lib -L/usr/lib/gcc/x86_64-linux-gnu/11/../../.. /tmp/cc5o7Jgg.o /tmp/ccUs2R16.o -lgcc --push-state --as-needed -lgcc_s --pop-state -lc -lgcc --push-state --as-needed -lgcc_s --pop-state /usr/lib/gcc/x86_64-linux-gnu/11/crtendS.o /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/crtn.o
~ COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'a.'
```

## バイナリファイルの種類

実行可能ファイル`a.out`に関連するバイナリファイルには
以下の4種類があります：
- オブジェクトファイル(`*.o`)
- 実行可能ファイル(`a.out`)
- 静的ライブラリファイル(`lib*.a`)
- 動的ライブラリファイル(`lib*.so`)

### オブジェクトファイル(`*.o`){#オブジェクトファイル}

**オブジェクトファイル**とはLinuxでファイル名の拡張子が`.o`なファイルです．
オブジェクトファイルは機械語命令を含んでいますが，
このオブジェクトファイル単体では実行することができません．
実行を可能にするには[**リンク**](#広義のコンパイル)(link)処理を経て，
[**実行可能ファイル**](#実行可能ファイル)
を作成する必要があります．

オブジェクトファイルは**再配置可能オブジェクトファイル**
(relocatable object file)と呼ばれることもあります．
オブジェクトファイルはリンク時に再配置（アドレス調整）が可能だからです．

### 実行可能ファイル(`a.out`){#実行可能ファイル}

**実行可能ファイル**(executable file)はその名前の通り，OSに実行を依頼すればそのままで実行できるバイナリファイルのことです．
例えば，hello wordの実行可能ファイル`a.out`はシェル上で以下のように実行できます．

```bash
$ ./a.out
hello， world
```

<details>
<summary>
シェルとは
</summary>

**シェル** (shell)とは「ユーザが入力したコマンドを解釈実行するプログラム」です．
例えば，`bash`, `zsh`, `csh`, `sh`, `ksh`, `tcsh`などはすべてシェルです．
Linux上ではユーザが自由にどのシェルを使うかを選ぶことができます．
シェルという名前は(OSの実体を**カーネル**(核)と呼ぶのに対して)
シェルがユーザに最も近い位置，つまりコンピュータシステムの外殻にあることに
由来してます(シェルの英語の意味は貝殻の殻(から)です)．
シェルは，ユーザが指定した`a.out`などのプログラムの実行を，
システムコール`execve`等を使ってOS(カーネル)に依頼します．

ちなみに**ターミナル** (端末，terminal)，あるいはターミナルエミュレータは，
ユーザの入出力処理を行うプログラムであり，ターミナル上でシェルは動作しています．
</details>

`ls`などのシェル上で実行可能なコマンドも実行可能ファイルです．

```bash
$ which ls
/usr/bin/ls
$ file /usr/bin/ls
/usr/bin/ls: ELF 64-bit LSB shared object， x86-64， version 1 (SYSV)， dynamically linked， ❶interpreter /lib64/ld-linux-x86-64.so.2， ❷BuildID[sha1]=2f15ad836be3339dec0e2e6a3c637e08e48aacbd， for GNU/Linux 3.2.0， stripped
$ ls
a.out add5.c add5.o add5.s
```


<p id="interpreter">
<details>
<summary>
❶interpreterとは
</summary>

ELFバイナリの動的リンカのことを（なぜか）interpreterと呼びます．
プログラミング言語処理系のインタプリタとは何の関係もありません．
ELFバイナリでは動的リンカのフルパスを指定することができ，
そのフルパス名をバイナリに埋め込みます．
この場合は `/lib64/ld-linux-x86-64.so.2` が埋め込まれています．
OSが`a.out`を実行する際に，
OSはまず動的リンカ(interpreter)をメモリにロードして，
ロードした動的リンカに制御を渡します．
動的リンカは`a.out`中の他の部分や，動的ライブラリをメモリにロードし，
動的リンクを行ってから，`a.out`の**エントリポイント**
(最初に実行を開始するアドレス)にジャンプします．
その後，いくつかの初期化を行ってから，`main`関数が呼び出されます．

`a.out`のエントリポイントは`readelf -h`コマンドで確認できます．
エントリポイントは`0x401050`番地でした❶．

```bash
$ readelf -h ./a.out
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement， little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
❶Entry point address:               0x401050
  Start of program headers:          64 (bytes into file)
  Start of section headers:          16832 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         13
  Size of section headers:           64 (bytes)
  Number of section headers:         36
  Section header string table index: 35
```
 
逆アセンブルすると`0x401050`番地は`_start`という関数がありました❷．
`a.out`は`_start`関数から実行が始まることが分かりました．

```bash
$ objdump -d ./a.out | egrep 401050 -A 5
0000000000401050 ❷ <_start>:
  401050:	f3 0f 1e fa          	endbr64 
  401054:	31 ed                	xor    %ebp，%ebp
  401056:	49 89 d1             	mov    %rdx，%r9
  401059:	5e                   	pop    %rsi
  40105a:	48 89 e2             	mov    %rsp，%rdx
  40105d:	48 83 e4 f0          	and    $0xfffffffffffffff0，%rsp
```
</details>
</p>

<details>
<summary>
❷BuildID[sha1]とは
</summary>

 BuildIDはバイナリファイルが同じかどうかを識別するユニークな番号（背番号）です．
ここでは`2f15`で始まる40桁の16進数が `/usr/bin/ls`のBuildIDです．
BuildIDはLinux ELF特有の機能です．
`strip`してもBuildIDは変化しないので，`strip`前後のファイルが同じかの確認に使えます．

```bash
$ gcc hello.c
$ cp a.out a.out.stripped
$ strip a.out.stripped
$ file a.out a.out.stripped
a.out:          ELF 64-bit LSB shared object， x86-64， version 1 (SYSV)， dynamically linked， interpreter /lib64/ld-linux-x86-64.so.2， BuildID[sha1]=308260da4f7fb6d4116c12670adf6e503637abba， for GNU/Linux 3.2.0， not stripped
a.out.stripped: ELF 64-bit LSB shared object， x86-64， version 1 (SYSV)， dynamically linked， interpreter /lib64/ld-linux-x86-64.so.2， BuildID[sha1]=308260da4f7fb6d4116c12670adf6e503637abba， for GNU/Linux 3.2.0， stripped
```

ここでは説明しませんが[**コアファイル**](./10-gdb.md#core-file) (core file)にもBuildIDが入っており，
そのコアファイルを出力した`a.out`を探すことができます．

ちなみにsha1はSHA-1を意味しており，SHA-1は160ビットのハッシュを生成するハッシュ関数です．
`git`のハッシュはSHA-1を使っています．
`sha1sum`コマンドでSHA-1のハッシュを計算できます．
 
```bash
$ sha1sum ./a.out
ff99525ad6a48d78d35d3108401af935a6ca9bbe  ./a.out
```
 
この結果から分かる通り，BuildIDのハッシュは，単純に`a.out`から作ったハッシュ値ではありません．
ELFバイナリのヘッダとセクションの一部からハッシュを計算しているようですが，正確な情報は見つかりませんでした(どうやら未公開のようです)．
</details>

実行可能なコマンドには実行可能ファイルではなく，
スクリプトなことがあります．

```bash
$ which shasum
/usr/bin/shasum
$ file /usr/bin/shasum
/usr/bin/shasum: Perl script text executable
$ head -3 /usr/bin/shasum
#!/usr/bin/perl
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
	if 0; # ^ Run only under a shell
```

`shasum`コマンドは(実行可能ファイルではなく)Perlスクリプトでした．

### 静的ライブラリ(`lib*.a`){#静的ライブラリ}

**静的ライブラリ**(static library)は[**静的リンク**](#静的リンクと動的リンク)
するときに使われるライブラリです．
**ライブラリ**とは複数のオブジェクトファイルを１つのファイルにまとめたもの（**アーカイブ**）です．

LinuxなどのUNIX系のOSでは静的ライブラリのファイル拡張子は`.a`が多いです．
またWindowsでは`.lib`です．
`printf`の実体が入っているC標準ライブラリの
静的ライブラリのファイル名は`libc.a`です．

### 動的ライブラリ(`lib*.so`){#動的ライブラリ}

**動的ライブラリ**(dynamic library)は[**動的リンク**](#静的リンクと動的リンク)
するときに使われるライブラリです．
動的ライブラリは**共有ライブラリ**(shared library)とも呼ばれます．
動的ライブラリは複数のプロセスからメモリ上で共有されるからです．

Linuxでは動的ライブラリのファイル拡張子は`.so`です(shared objectの略)．
処理系の都合でファイル拡張子に数字がつくことがあります（例：`.so.6`）．
動的ライブラリのファイル拡張子はUnix系のOSでも様々です．
Windowsでは`.dll`です．

## 静的リンクと動的リンク{#静的リンクと動的リンク}

静的ライブラリは静的リンクに使われるライブラリで，
動的ライブラリは動的リンクに使われるライブラリです．

### 静的リンク

**静的リンク**とは**コンパイル時**にリンクを行う手法です．
仕組みは単純ですが，ファイルやメモリの使用量が増える欠点があります．
[この図](#fig:compile-all)で説明したリンクは実は静的リンクでした．

静的リンクしたファイル`a.out`はリンク済みなので，
ライブラリ関数(例えば`printf`)の実体も`a.out`の中に入っています．

<img src="figs/static-link-printf.svg" height="200px" id="fig:static-link-printf">

`a.out`ごとに`printf`のコピーが作られるので，
ファイルの使用量が無駄に増えてしまいます．
また`a.out`中の`printf`は実行時にもメモリ上で**共有されない**ので，
メモリの使用量も無駄に増えてしまいます．


### 静的リンクでコンパイルしてみる

```C
// hello.c
#include <stdio.h>
int main (int ac, char **ag)
{
    printf ("hello (%d)\n", ac);
}
```

静的リンクするには`-static`オプションをつけます（`-static`無しだと動的リンクになります）．
`printf`に第2引数を与えているのは，こうしないと，コンパイラが勝手に
`printf`の呼び出しを`puts`に変更してしまうことがあるからです．

`a.out`を`file`コマンドで確認すると`statically linked`とあり❶，
静的リンクできたことが分かります．

```bash
$ gcc -static hello.c
$ file ./a.out
./a.out: ELF 64-bit LSB executable， x86-64， version 1 (GNU/Linux)， ❶statically linked， BuildID[sha1]=40fe6c0daaf2d49fabad4d37bc34fcdd12cb8da9， for GNU/Linux 3.2.0， not stripped
$ ./a.out
hello (1)
```

<details>
<summary>
練習問題：静的にリンクしたa.out中にprintfの実体があることを確認せよ
</summary>

`a.out`を逆アセンブルし，❶`<main>:`を含む行から15行を表示させます．
(❷`-A 14`は「マッチした行の後ろ14行も表示する」というオプションです)．
 `main`関数は(`printf`ではなく)❸`_IO_printf`を呼び出していることを確認できます．

```bash
$ objdump -d ./a.out | egrep ❷-A 14 ❶"<main>:"
0000000000401cb5 <main>:
  401cb5:	f3 0f 1e fa          	endbr64 
  401cb9:	55                   	push   %rbp
  401cba:	48 89 e5             	mov    %rsp，%rbp
  401cbd:	48 83 ec 10          	sub    $0x10，%rsp
  401cc1:	89 7d fc             	mov    %edi，-0x4(%rbp)
  401cc4:	48 89 75 f0          	mov    %rsi，-0x10(%rbp)
  401cc8:	8b 45 fc             	mov    -0x4(%rbp)，%eax
  401ccb:	89 c6                	mov    %eax，%esi
  401ccd:	48 8d 3d 30 33 09 00 	lea    0x93330(%rip)，%rdi        # 495004 <_IO_stdin_used+0x4>
  401cd4:	b8 00 00 00 00       	mov    $0x0，%eax
  401cd9:	e8 72 ec 00 00       	callq  410950 ❸<_IO_printf>
  401cde:	b8 00 00 00 00       	mov    $0x0，%eax
  401ce3:	c9                   	leaveq 
  401ce4:	c3                   	retq   
``` 

> 注：ここでは`egrep -A 14`としてますが，皆さんが試す時は，
>
> ```bash
> $ objdump -d ./a.out | less
> ```
>
> としてから，`/<main>:`とリターンを入力して検索する方が便利でしょう．
 
次に同じく`a.out`を逆アセンブルし，`<_IO_printf>:'を含む行から数行を表示させます．

```bash
$ objdump -d ./a.out | egrep -A 5 "<_IO_printf>:"
0000000000410950 <_IO_printf>:
  410950:	f3 0f 1e fa          	endbr64 
  410954:	48 81 ec d8 00 00 00 	sub    $0xd8，%rsp
  41095b:	49 89 fa             	mov    %rdi，%r10
  41095e:	48 89 74 24 28       	mov    %rsi，0x28(%rsp)
  410963:	48 89 54 24 30       	mov    %rdx，0x30(%rsp)
``` 
 
これは`_IO_printf`の定義なので，`a.out`に`printf`の実体があることを確認できました．
なお，以下の`nm`コマンドでも，`a.out`に`printf`の実体があることを確認できます．
 
```bash
$ nm ./a.out | egrep _IO_printf
0000000000410950 T _IO_printf
```

実は`_IO_printf`も`printf`も実体は同じです．処理系の都合で，
「実体は同じだけど別の名前をつける」ことがあり，それをエイリアス（別名）といいます．
0x410950番地で調べると，これを確認できます．

```bash
$ nm ./a.out | egrep 410950
0000000000410950 T _IO_printf
0000000000410950 T __printf
0000000000410950 T printf
```
</details>


### 動的リンク

**動的リンク**とは実行を始める際の**ロード時**（`a.out`をメモリにコピーする時）
あるいは**実行途中**にメモリ上でリンクを行う手法です．
現在ではファイルやメモリの消費量を抑えるため，デフォルトで動的リンクが使われることが多いです．

動的リンクしたファイル`a.out`には
「ライブラリ関数(例えば`printf`)とのリンクが必要だよ」という
小さな参照情報だけが入っており，`printf`の実体は入っていません．
実際のリンクは実行時にメモリ上で行います．

<img src="figs/dynamic-link-printf.svg" height="200px" id="fig:dynamic-link-printf">

`a.out`には`printf`を含まないので，ファイルの使用量を抑えられます．
また`a.out`中の`printf`は実行時にはメモリ上で**共有される**ので，
メモリの使用量も抑えられます．

ファイルサイズを比較してみると，静的リンクした`a.out-static`は約870KB，
動的リンクした`a.out-dynamic`は約17KBで，50倍ものサイズ差がありました．

```bash
$ gcc -static -o a.out-static hello.c
$ gcc -o a.out-dynamic hello.c
$ ls -l a.out*
-rwxrwxr-x 1 gondow gondow  16696 Jul 20 17:52 a.out-dynamic
-rwxrwxr-x 1 gondow gondow 871832 Jul 20 17:51 a.out-static
```

### 動的リンクでコンパイルしてみる

Linuxでは`-static`オプションをつけなければ動的リンクになります．

```bash
$ gcc hello.c
$ file a.out
a.out: ELF 64-bit LSB shared object， x86-64， version 1 (SYSV)， dynamically linked， interpreter /lib64/ld-linux-x86-64.so.2， BuildID[sha1]=308260da4f7fb6d4116c12670adf6e503637abba， for GNU/Linux 3.2.0， not stripped
$ ./a.out
hello (1)
```

実行時にリンクが必要な動的ライブラリの情報は`ldd`コマンドで表示できます．

```bash
$ ldd ./a.out
	❶linux-vdso.so.1 (0x00007ffd21638000)
	❷libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fcfef5c1000)
	❸/lib64/ld-linux-x86-64.so.2 (0x00007fcfef7d8000)

```

この`a.out`は`linux-vsdo.so.1`，`libc.so.6`，`ld-linux-x86-64.so.2`という
3つの動的ライブラリと実行時にリンクする必要があることを表示しています．
`libc.so.6`は（`LD_LIBRARY_PATH`などの設定がなければ）
絶対パス`/lib/x86_64-linux-gnu/libc.so.6`とリンクされます．

<details>
<summary>
❶linux-vdso.so.1とは
</summary>

vDSO (virtual dynamic shared objectの略)で，カーネル空間で実行する必要が無い
システムコール(例えば`gettimeofday`)を高速に実行するための仕組みです．

- [Implementing virtual system calls](https://lwn.net/Articles/615809/)
- [man vdso](https://man7.org/linux/man-pages/man7/vdso.7.html)
</details>

<details>
<summary>
❷libc.so.6とは
</summary>

C標準ライブラリが入った動的ライブラリです．
`nm -D`コマンドで調べると，`printf`の実体が入っていることが分かります．
(`-D`は共有ライブラリで使われる動的シンボルを表示させるオプションです）

```bash
$ nm -D /lib/x86_64-linux-gnu/libc.so.6 | egrep ' T printf'
0000000000061c90 T printf
0000000000061100 T printf_size
0000000000061bb0 T printf_size_info
```

`-D`オプションをつけないと「❶シンボルが無いよ」と言われてしまいます．
(動的シンボル以外は`strip`されているからです)

```bash
$ nm /lib/x86_64-linux-gnu/libc.so.6
nm: /lib/x86_64-linux-gnu/libc.so.6: ❶no symbols
```
</details>

<details>
<summary>
❸ld-linux-x86-64.so.2とは
</summary>

動的リンクを行うプログラム（共有ライブラリ），つまり動的リンカです．
[interpreterとは](#interpreter)も参照下さい．

- [man ld-linux.so](https://man7.org/linux/man-pages/man8/ld.so.8.html)
</details>

<details id="LD_LIBRARY_PATH">
<summary>
LD_LIBRARY_PATHとは
</summary>

`a.out`実行時には，
動的リンカは動的ライブラリをある手順に従って検索します（詳細は`man ld`）．
通常はデフォルトのパス（`/lib`や`/usr/lib`など）にある動的ライブラリを使いますが，
環境変数`LD_LIBRARY_PATH`にディレクトリ（複数ある場合は
コロン`:`で区切る）をセットすることで検索パスを追加できます．
具体的には，
動的リンカは`LD_LIBRARY_PATH`で指定したディレクトリを
（デフォルトの検索パスよりも先に）検索し，
そこにある動的ライブラリを優先的に使います．
（[`LD_RUN_PATH`](#LD_RUN_PATH)も参照下さい）．
</details>

<details>
<summary>
練習問題：動的にリンクしたa.out中にprintfの実体が無いことを確認せよ
</summary>

`nm`コマンドで`a.out`には`main`を始めごく少数の
関数しか定義しておらず，その中に`printf`は入っていないことが以下で確認できます．
 
```bash
$ nm ./a.out | egrep ' T '
00000000000011f8 T _fini
00000000000011f0 T __libc_csu_fini
0000000000001180 T __libc_csu_init
0000000000001149 T main
0000000000001060 T _start
```

また`nm`の出力を`printf`で検索すると，GLIBC中の`printf`への参照はあるが
`a.out`中では未定義(`U`)となっていることが分かります．

```bash
$ nm ./a.out | egrep 'printf'
                 U printf@@GLIBC_2.34
```
 
<div  id="GOT-PLT">

なお逆アセンブルすると`<printf@plt>`という小さな関数が見つかりますが，
これは`printf`の実体ではありません．

```bash
$ objdump -d ./a.out | egrep -A 5 "<printf"
0000000000001050 <printf@plt>:
    1050:	f3 0f 1e fa          	endbr64 
    1054:	f2 ff 25 75 2f 00 00 	bnd jmpq ❶*0x2f75(%rip)        # 3fd0 <printf@GLIBC_2.34>
    105b:	0f 1f 44 00 00       	nopl   0x0(%rax，%rax，1)
```

`<printf@plt>`は`printf`を呼び出す単なる踏み台で，
PLT (procedure linkage table)という仕組みです．
PLTは`printf`の最初の呼び出しまで`printf`の**アドレス解決**
(address resolution)を遅延します．具体的には次の2ステップになります．
 
- `printf@plt`の間接ジャンプ先❶の初期値は「動的リンクする関数（動的リンカ）」になっているため，最初に`printf@plt`が呼ばれると，動的リンクを行い，その結果，間接ジャンプ先が「`printf`の実体」に変更されます❷．
そして動的リンカは何もなかったかのように`printf`を呼び出します．
（ちなみに`printf@plt`の間接ジャンプで参照するメモリ領域は GOT (global offset table)と呼ばれます）
- その結果，2回目以降の以下の間接ジャンプ❶では(動的リンカを経由せずに)`printf`が呼ばれます．
 
つまり，GOTに`printf`のアドレスを格納することが，ここではアドレス解決になっています．

<img src="figs/plt-printf.svg" height="400px" id="fig:plt-printf">

</div>
 
</details>

### 静的ライブラリを作成してみる

<p id="main.c-static">

```C
// main.c
#include <stdio.h>
int add5 (int n);
int main (void)
{
    printf ("%d\n", add5 (10));
}
```
</p>

<p id="add5.c-static">

```C
// add5.c
int add5 (int n)
{
    return n + 5;
}
```
</p>

```bash
$ gcc -c add5.c   
$ ar rcs libadd5.a add5.o  ❶
$ ar t libadd5.a
add5.o  ❷
$ file libadd5.a
libadd5.a: current ar archive
$ gcc ❸-static -o a.out-static main.c ❹-L. ❺-ladd5
$ file a.out-static
file ./a.out-static
./a.out-static: ELF 64-bit LSB executable， x86-64， version 1 (GNU/Linux)， statically linked， BuildID[sha1]=1bf84a77504302513d6219e4b27316309d08ed2d， for GNU/Linux 3.2.0， not stripped
$ ./a.out-static 
15 ❻
```


- ❶ `ar rcs`コマンドで`add5.o`から`libadd5.a`を作成します．
- ❷  `ar t`コマンドで`libadd5.a`の中身を調べます．中身は`add5.o`だけでした．
- ❸❹❺ `gcc`で`main.c`と`libadd5.a`を静的リンクします．
  静的リンクするために❸`-static`オプションが必要です．
  `libadd5.a`がカレントディレクトリにあることを伝えるために❹`-L.`が必要です．
  静的リンクする静的ライブラリが`libadd5.a`であることを伝えるために
  ❺`-ladd5`が必要です．（前の`lib`と後の`.a`は自動的に付加されます）
- ❻ 実行してみると，静的ライブラリ`libadd5.a`中の`add5`関数を呼び出せました．

### 動的ライブラリを作成してみる

[`add5.c`](#add5.c-static)と[`main.c`](#main.c-static)は
前節と同じものを使います．

```bash
$ gcc -c add5.c   
$ gcc ❶-fPIC ❷-shared -o libadd5.so add5.o
$ file libadd5.so
libadd5.so: ELF 64-bit LSB shared object， x86-64， version 1 (SYSV)， dynamically linked， BuildID[sha1]=415ef51f32145b59c51e836a25959f0f66039768， not stripped
$ gcc main.c -ladd5 -L. ❸-Wl，-rpath .
$ file ./a.out
./a.out: ELF 64-bit LSB shared object， x86-64， version 1 (SYSV)， dynamically linked， interpreter /lib64/ld-linux-x86-64.so.2， BuildID[sha1]=a5d4f8ef61cef4e0b063376333f07170d312c546， for GNU/Linux 3.2.0， not stripped
$ ldd ./a.out
	linux-vdso.so.1 (0x00007ffff7fcd000)
	libadd5.so => ❹./libadd5.so (0x00007ffff7fbd000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ffff7dad000)
	/lib64/ld-linux-x86-64.so.2 (0x00007ffff7fcf000)
$ ./a.out
15 ❺ 
```

- ❶❷ `add5.c`から動的ライブラリ`libadd5.so`を作ります．
  `libadd5.so`を**位置独立コード**(PIC)にするために，❶`-fPIC`が必要です．
  `libadd5.so`を**共有オブジェクト**(shared object)にするために，❷`-shared`が必要です．
- ❸ `gcc`で`main.c`と`libadd5.so`を動的リンクします．
  実行時に動的ライブラリを探索するパスを❸`-Wl，-rpath .`で指定しています．
  ここでは`libadd5.so`をカレントディレクトリに置いているためです．
  （セキュリティ上，実際に使う際は絶対パスを指定する方が安全でしょう）．
  ちなみに`-Wl，-rpath .`を`gcc`に指定すると，
  [`ld`コマンド](https://man7.org/linux/man-pages/man1/ld.1.html)
  に`-rpath .`というオプションが渡されます	．
- ❹ `ldd`コマンドで調べると，`a.out`中の`libadd5.so`は
  `./libadd5.so`を参照していることを確認できました．
- ❺ 実行してみると，動的ライブラリ`libadd5.so`中の`add5`関数を呼び出せました．

<details ID="LD_RUN_PATH">
<summary>
-rpath，LD_RUN_PATH，LD_LIBRARY_PATH
</summary>

❸`-Wl，-rpath .`はコンパイル時に「動的ライブラリの検索パス」を`a.out`中に埋め込みます．
以下のコマンド等で確認できます（❻の部分）．

```
$ readelf -d ./a.out | egrep PATH
 0x000000000000001d (RUNPATH)            Library runpath: ❻[.]
```

`-Wl，-rpath .`で指定する検索パスは環境変数`LD_RUN_PATH`でも指定できます．
（複数の検索パスはコロン`:`で区切ります）．

```
$ export LD_RUN_PATH="."
$ gcc main.c -ladd5 -L. 
$ readelf -d ./a.out | egrep PATH
 0x000000000000001d (RUNPATH)            Library runpath: [.]
```

[`LD_LIBRARY_PATH`](#LD_LIBRARY_PATH)を使うと，
`a.out`中の検索パス以外の動的ライブラリを実行時に動的リンクできます．
例えば，以下で`ldd`コマンドを使うと，
`/tmp/libadd5.so`が使われることを確認できます❼．

```
$ export LD_LIBRARY_PATH="/tmp"
$ cp libadd5.so /tmp
$ ldd ./a.out
	libadd5.so => ❼/tmp/libadd5.so (0x00007ffffffb8000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fffffd8b000)
	/lib64/ld-linux-x86-64.so.2 (0x00007ffffffc4000)
```

なお`LD_LIBRARY_PATH`は危険で強力なので，なるべく使うのは避けるべきです．
使う場合は最新の注意を払って使いましょう．
なぜならば，例えば，`/tmp/libc.so.6`という悪意のある動的ライブラリがあると，
`/tmp/libc.so.6`中の`printf`が呼び出されてしまうからです．
（この`printf`の中身はコンピュータウイルスかも知れません）

</details>

<details id="PIC">
<summary>
位置独立コードとは
</summary>

**位置独立コード**(position independent code， PIC)とはメモリ上の
どこにロードしても，そのまま実行できるコードです．
位置独立コードでは絶対アドレスは使わず（再配置が必要になってしまうから），
相対アドレスか間接アドレス参照だけを使います．
位置独立コードにすることで，メモリ上で動的ライブラリを共有できるため，
メモリ使用量を抑えることができます．
</details>

## デバッグ情報

### デバッグ情報とは

**デバッグ情報**とは`gcc`に`-g`オプションをつけると
バイナリに付加される情報で，
デバッグ時に有用なソースコード中の情報を含んでいます．
例えば，変数の型情報や，ソースコード中の行番号が挙げられます．

```bash
$ gcc ❶ -g main.c add5.c
$ file ./a.out
./a.out: ELF 64-bit LSB pie executable， x86-64， version 1 (SYSV)， dynamically linked， interpreter /lib64/ld-linux-x86-64.so.2， BuildID[sha1]=68a01f5977ae542600062913c447a7ba7f2fad62， for GNU/Linux 3.2.0， ❷ with debug_info， not stripped
```

❶`-g`オプションをつけてコンパイルしてから，`file`コマンドで調べると，
❷デバッグ情報が含まれていることを確認できます．

コンパイラは様々なデバッグ情報の形式を扱えます．
LinuxのELFバイナリでは[DWARFデバッグ情報](https://dwarfstd.org/doc/DWARF5.pdf)
が使われることが多いです．(以下，DWARFを前提として説明します)

### デバッグ情報が無いと，デバッガでファイル名や行番号が表示されない {#no-debug-info}

デバッグ情報無しでデバッガ`gdb`を使うとどうなるか試してみましょう．
[`add5.c`](#add5.c-static)と[`main.c`](#main.c-static)は
前節と同じものを使います．
(`gdb`の使い方の詳細は[デバッガgdbの使い方](./10-gdb.md)を参照下さい)．

```bash
$ gcc ❶ main.c add5.c
$ gdb ./a.out
(gdb) ❷ b add5
Breakpoint 1 at 0x1175
(gdb) ❸ r
Starting program: /tmp/a.out 
Breakpoint 1， 0x0000555555555175 in ❹ add5 ()
(gdb) bt
#0 ❻ 0x0000555555555175 in ❺ add5 ()
#1    0x000055555555515b in    main ()
(gdb) quit
```

`-g`オプション無しで❶コンパイルしています．
`add5`関数にブレークポイントを設定❷します．
**ブレークポイント**とはプログラムの実行を一時的に停止する場所です．
関数名`add5`でブレークポイントを指定したので，
実行すると`add5`関数の先頭で実行が一時停止します．

❸ runコマンド (`r`はrunコマンドの省略形)で実行した所，
`add5`関数でブレーク(実行を一時停止)できたのですが，
関数名`add5`だけが表示され，**ファイル名や行番号が表示されません**❹．
バックトレースを出力しても同様です❺．

バックトレースとは「`main`関数から現在実行中の関数までの，
関数呼び出し系列」のことです．
ここでは`main`関数が`add5`関数を呼び出しただけなので，
バックトレースは2行しかありません．
❻`0x0000555555555175`は`add5`関数が
`0x0000555555555175`番地の機械語命令を実行する直前で実行を停止していることを
示しています．

### デバッグ情報があると，デバッガでファイル名や行番号が表示される

今回はデバッグ情報ありでデバッガを使ってみます．

```bash
$ gcc ❶ -g main.c add5.c
$ gdb ./a.out
(gdb) b add5
Breakpoint 1 at 0x1175: ❷ file add5.c， line 2.
(gdb) r
Starting program: /tmp/a.out 
Breakpoint 1， add5 (n=10) at ❸ add5.c:2
2	{
(gdb) bt
#0  add5 (n=10) at ❹ add5.c:2
#1  0x000055555555515b in main () at main.c:5

$ gcc ❶ -g main.c add5.c
$ gdb ./a.out
(gdb) b add5
Breakpoint 1 at 0x1183: ❷ file add5.c， line 3.
(gdb) r
Breakpoint 1， add5 (n=10) at ❸ add5.c:3
3	    return n + 5;
(gdb) bt
#0  add5 (n=10) at ❹ add5.c:3
#1  0x000055555555515b in main () at main.c:5
```

- ❶ `-g`をつけたので，`a.out`にはデバッグ情報が付加されています．
- [先程](#no-debug-info)とは異なり，❷❸❹ファイル名`add5.c`や行番号`3`が付加されています．

### デバッグ情報があると，行番号とアドレスを相互変換できる．

#### アドレス→行番号の変換{#addr2line}

デバッグ情報があるバイナリに対しては，
`addr2line`コマンドでアドレスを対応する行番号に変換できます．

```bash
$ gcc -g main.c add5.c
$ objdump -d ./a.out | egrep -A 4 "<main>:"
0000000000001149 <main>:
    1149:	f3 0f 1e fa          	endbr64 
    114d:	55                   	push   %rbp
    114e:	48 89 e5             	mov    %rsp，%rbp
    1151:	bf 0a 00 00 00       	mov    $0xa，%edi
$  addr2line -e ./a.out ❶ 0x1149
❷/tmp/main.c:4
```

上の実行例では`addr2line`コマンドで，
`0x1149`番地の機械語命令はソースコードでは❷`/tmp/main.c`の4行目に
対応していることが分かりました．

デバッガ上でも確かめてみましょう．

```
(gdb) b main
Breakpoint 1 at 0x1151: file main.c， line 5.
(gdb) r
Breakpoint 1， main () at main.c:5
5	    printf ("%d\n"， add5 (10));
(gdb) ❶ disas
Dump of assembler code for function main:
   0x0000555555555149 <+0>:	endbr64 
   0x000055555555514d <+4>:	push   %rbp
   0x000055555555514e <+5>:	mov    %rsp，%rbp
=> 0x0000555555555151 <+8>:	mov    $0xa，%edi
   0x0000555555555156 <+13>:	call   0x555555555178 <add5>
(以下略)
(gdb) ❷ info line *0x0000555555555149 
Line 4 of "main.c" starts at address 0x555555555149 <main>
   and ends at 0x555555555151 <main+8>.
(gdb) ❸ info line main.c:4
Line 4 of "main.c" starts at address 0x555555555149 <main>
   and ends at 0x555555555151 <main+8>.
```

- (objdumpコマンドでも可能ですが)
  `gdb`上でも逆アセンブルできます．
  逆アセンブルのコマンドは`disassemble`ですが長いので，
  短縮名`disas`をここでは使っています．
  (`gdb`は他のコマンドと区別できる範囲で，コマンド名を省略できます)．
  [ASLRとPIE](#ASLR-PIE)が有効な場合，
  デバッガ上で逆アセンブルすると，実際のメモリのアドレスが表示されて便利です．
  この場合，[上](#addr2line)では`0x1149`番地だったのに，
  `0x0000555555555149`番地に変わっています．
- `gdb`の❷`info line`コマンドを使うと，アドレスから行番号に変換できます．
  `0x555555555149`番地は`main.c`の4行目に対応しており，
  また，この行は機械語命令では`0x555555555149`番地から`0x555555555151`に
  対応していると表示されています．
- `gdb`上では❸`info line`コマンドを使って，
  行番号からアドレスへの変換もできます．

なお，`gdb`で`layout asm`とすると逆アセンブル結果を常に表示できます．
ブレークポイント(左端の`b`や`B`)や次に実行する機械語命令の位置(`>`)が
表示されて分かりやすいです．

<img src="figs/gdb-layout-asm.png" height="300px" id="fig:gdb-layout-asm">

<details>
<summary>
B+ってどういう意味
</summary>

- `B`は少なくても一度はブレークしたブレークポイント
- `b`は一度もブレークしていないブレークポイント
- `+`は有効化されているブレークポイント
- `-`は無効化されているブレークポイント
</details>

  
#### 行番号→アドレスの変換

コマンドライン上で，行番号をアドレスに変換するには
(コマンドがちょっと長くなりますが)以下のように`gdb`を使います．
  
```bash
$ gdb ./a.out -ex "info line main.c:4" --batch
Line 4 of "main.c" starts at address ❶0x1149 <main> and ends at 0x1151 <main+8>.
```

上ではプログラムを実行せずにアドレスを取得したので，
`a.out`ファイル中のアドレス❶`0x1149`が表示されています．
実行時のアドレスを表示したいなら，以下のようにします
(バッチモードで，`b main`，`run`，`info line main.c:4`という3つのコマンドを実行しています)．
実行時のアドレス❷`0x555555555149`を表示できました．

```bash
$ gdb ./a.out -ex "b main" -ex "r" -ex "info line main.c:4" --batch
Breakpoint 1， main () at main.c:5
5	    printf ("%d\n"， add5 (10));
Line 4 of "main.c" starts at address ❷0x555555555149 <main> and ends at 0x555555555151 <main+8>.
```

以下のように`line2addr`などの名前でシェル関数を定義すれば，
短く書けます(が，そんなに頻繁には使わないかも)．

```bash
$ function line2addr () {
> command gdb $1 -ex "info line $2" --batch
> }
$ line2addr ./a.out main.c:4
Line 4 of "main.c" starts at address 0x1149 <main> and ends at 0x1151 <main+8>.
```

### デバッグ情報があると，逆アセンブル時にソースコードも表示できる

デバッグ情報がある場合，
(`objdump -d`ではなく)`objdump -S`で逆アセンブルすると
ソースコードも表示できます．
❶関数`add5`の定義部分であること，
❷`return n + 5;`の行のコンパイル結果であること，
などが見やすくなります．

```bash
$ gcc -g -c add5.c
$ objdump -S ./add5.o
./add5.o:     file format elf64-x86-64
Disassembly of section .text:
0000000000000000 <add5>:
❶ int add5 (int n)
{
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	48 89 e5             	mov    %rsp，%rbp
   8:	89 7d fc             	mov    %edi，-0x4(%rbp)
 ❷ return n + 5;
   b:	8b 45 fc             	mov    -0x4(%rbp)，%eax
   e:	83 c0 05             	add    $0x5，%eax
}
  11:	5d                   	pop    %rbp
  12:	c3                   	ret    
```

### デバッガでレジスタの値を確認する

デバッガでレジスタの値を確認できます．

```bash
$ gcc -g main.c add5.c
$ gdb ./aout
(gdb) b add5
Breakpoint 1 at 0x1183: file add5.c， line 3.
(gdb) r
Breakpoint 1， add5 (n=10) at add5.c:3
3	    return n + 5;
(gdb) p ❶ $rdi
$1 = 10
(gdb) ❷ info reg
Undefined info command: "regs".  Try "help info".
(gdb) info reg
rax            0x555555555149      93824992235849
rbx            0x0                 0
rcx            0x555555557dc0      93824992247232
rdx            0x7fffffffe048      140737488347208
rsi            0x7fffffffe038      140737488347192
rdi            0xa                 10
(以下略，qを押して表示を停止)
```

- ❶ `gdb`では`%`ではなく`$`をつけてレジスタ名を指定します．
  `p`は`print`コマンドの省略名です．`%rdi`の値が`10`であることが分かりました．
  16進数で表示したい場合は，`p/x $rdi`と`/x`をつけます
- ❷ レジスタの値一覧は`info reg`で表示できます．ページャが起動されるので，`q`を押して表示を停止します．

`gdb`で`layout regs`とすると，レジスタの値を常に表示できます．

<img src="figs/gdb-layout-regs.png" height="300px" id="fig:gdb-layout-regs">

- `layout regs`するとレジスタの値一覧が表示されます．
  上から「レジスタ表示」「ソースコード表示」「コマンド入力」のためのウィンドウです．
- `focus regs`や，`ctrl-x o`などを入力すると，レジスタ表示ウィンドウが選択されます．
  この状態で↓キーを押すと(あるいはマウスでスクロールされると）
  レジスタ表示ウィンドウの表示をスクロールできます．
- `ctrl-x a`を入力すると，元の表示方法に戻ります．

### デバッガでメモリの値を確認する

[`add5.c`](#add5.c-static)と[`main.c`](#main.c-static)を
を実行し，`add5`関数のスタックフレームが作成された直後は
以下の図([ここ](./2-asm-intro.md#create-new-stack-frame)で使った図の再掲)
になっています．

 <img src="figs/stack-frame4-4.svg" height="143px" id="fig:stack-frame4-4">

これをデバッガで確認しましょう．

```bash
$ gcc -g main.c add5.c
$ gdb ./a.out
(gdb) b add5
Breakpoint 1 at 0x1183: file add5.c， line 3.
(gdb) r
Breakpoint 1， add5 (n=10) at add5.c:3
3	    return n + 5;
(gdb) disas
Dump of assembler code for function add5:
   0x0000555555555178 <+0>:	endbr64 
   0x000055555555517c <+4>:	push   %rbp
   0x000055555555517d <+5>:	mov    %rsp，%rbp
   0x0000555555555180 <+8>:	mov    %edi，-0x4(%rbp)
=> 0x0000555555555183 <+11>:	mov    -0x4(%rbp)，%eax
   0x0000555555555186 <+14>:	add    $0x5，%eax
   0x0000555555555189 <+17>:	pop    %rbp
   0x000055555555518a <+18>:	ret    
(gdb) ❶ p/x $rsp
$1 = 0x7fffffffdf10
(gdb) ❷ p/x $rbp
$2 = 0x7fffffffdf10
(gdb) ❸ x/1gx 0x7fffffffdf10
0x7fffffffdf10:	0x00007fffffffdf20
(gdb) ❹ x/1gx $rsp
0x7fffffffdf10:	0x00007fffffffdf20
(gdb) ❺ x/8bx $rsp
0x7fffffffdf10:	0x20 0xdf 0xff 0xff 0xff 0x7f 0x00 0x00
```

- ❶❷ `%rsp`と`%rbp`レジスタの値を調べると，どちらも
  `0x7fffffffdf10`番地でした．
- ❸ `x/1gx 0x7fffffffdf10` はメモリの中身を表示するコマンドです．

  - `x`のコマンド名は examine memory から来ています．
  - `/1gx`は出力形式を指定しています．
    この場合は「8バイトのデータを16進表記で1つ表示」という意味です．

<details>
<summary>
xコマンドの表示オプション
</summary>

`x`コマンドの表示オプションには以下があります(他にもあります)．
    
- `x`  16進数
- `d`  符号あり10進数
- `u`  符号なし10進数
- `t`   2進数
- `c`  文字
- `s`  文字列

データのサイズ指定には以下があります．

- `b`  1バイト (byte)
- `h`  2バイト (halfword)
- `w`  4バイト (word)
- `g`  8バイト (giant)
</details>

<details>
<summary>
サイズの用語がバラバラ過ぎる！
</summary>

以下の通り，GNUアセンブラ(AT&T形式)，Intel形式，`gdb`で各サイズに対する
用語がバラバラです．混乱しやすいので要注意です．

| | 1バイト | 2バイト | 4バイト | 8バイト |
| - | - | - | - | - |
|GNUアセンブラ | byte (b) | short (s) | long (l) | quad (q) |
|Intel形式 | byte | word | double word (dword) | quad word (qword) |
| `gdb` | byte (b) | halfword (h) | word (w) | giant (g) |
</details>

- ❹ 具体的なアドレス(ここでは`0x7fffffffdf10`)ではなく，
  レジスタ名 (ここでは`$rsp`)を指定して，
 　そのレジスタが指しているメモリの中身を表示できます．
- ❺ `/1gx`ではなく`/8bx`と表示形式を指定すると，
   「1バイトのデータを16進表記で8個表示」という意味になります．
  `0x7FFFFFFFDF10`から`0x7FFFFFFFDF17`までの各番地には，それぞれ，
  以下の図の通り，
  `0x20`，`0xDF`，`0xFF`，`0xFF`，`0xFF`，`0x7F`，`0x00`，`0x00`という値が
  メモリ中に入っていることが分かります．
  この格納されている8バイトのデータ`0x00007fffffffdf20`はアドレスであり，
  以下の図の一番下のアドレス(赤字の部分)を指しています．

<img src="figs/stack-add5-layout.svg" height="350px" id="fig:stack-add5-layout">

```
(上のデバッグの続き)
(gdb) ❻ x/1gx $rsp+8
0x7fffffffdf18:	0x000055555555515b
(gdb) ❼ x/8bx $rsp+8
0x7fffffffdf18:	0x5b	0x51	0x55	0x55	0x55	0x55	0x00	0x00
(gdb) ❽ disas 0x000055555555515b
Dump of assembler code for function main:
   0x0000555555555149 <+0>:	endbr64 
   0x000055555555514d <+4>:	push   %rbp
   0x000055555555514e <+5>:	mov    %rsp，%rbp
   0x0000555555555151 <+8>:	mov    $0xa，%edi
   0x0000555555555156 <+13>:	call   0x555555555178 <add5>
❾ 0x000055555555515b <+18>:	mov    %eax，%esi
   0x000055555555515d <+20>:	lea    0xea0(%rip)，%rax        # 0x555555556004
   0x0000555555555164 <+27>:	mov    %rax，%rdi
   0x0000555555555167 <+30>:	mov    $0x0，%eax
   0x000055555555516c <+35>:	call   0x555555555050 <printf@plt>
   0x0000555555555171 <+40>:	mov    $0x0，%eax
   0x0000555555555176 <+45>:	pop    %rbp
   0x0000555555555177 <+46>:	ret    
End of assembler dump.
```

- ❻ `x/1gx`を使って，上の図の`8(%rsp)`のアドレスの中身を表示させています．
  `8(%rsp)`の意味は「`%rsp`の値に8を足したアドレス」です．
  `gdb`中では「`$rsp + 8`」と入力します．
- ❼ `x/8bx`を使って，上の図の`8(%rsp)`のアドレスを1バイトごとに表示しました．
  上記の図の通り， 
  `0x7FFFFFFFDF18`から`0x7FFFFFFFDF1F`までの各番地には，それぞれ，
  `0x5B`，`0x51`，`0x55`，`0x55`，`0x55`，`0x55`，`0x00`，`0x00`が
  格納されていることが分かりました．
- ❻の結果で得た`0x000055555555515b`番地を使って❽逆アセンブルしてみると，
  ❾この番地は「`call add5`」の次の命令 (この場合は `mov %eax， %esi`)であることが
  分かりました．
  このように，**戻り番地** (return address)は通常，
  「その関数を呼び出した`call`命令の次の命令のアドレス」になります．

<details>
<summary>
戻り番地が通常ではない場合って?
</summary>

**末尾コール最適化** (tail-call optimization; TCO)が起こった時が該当します．

<form class="tab-wrap">
    <input id="tail-call-opt1" type="radio" name="TAB" class="tab-switch" checked="checked" />
    <label class="tab-label" for="tail-call-opt1">末尾コール最適化の前</label>
    <div class="tab-content">
    	 <img src="figs/tail-call-opt1.svg" height="150px" id="fig:tail-call1-opt">
    </div>
    <input id="tail-call-opt2" type="radio" name="TAB" class="tab-switch" />
    <label class="tab-label" for="tail-call-opt2">末尾コール最適化後</label>
    <div class="tab-content">
    	 <img src="figs/tail-call-opt2.svg" height="140px" id="fig:tail-call-opt2">
    </div>
</form>

- 上の「末尾コール最適化の前」の図では`main`関数が`A`を呼び，
 関数`A`が`B`を呼んでいます．また逆の順番でリターンします．
  しかし，`call B`の次の命令が`ret` (次の命令❷)になっているため，
   関数`B`からリターンした後，関数`A`では何もせず，`main`にリターンしています．
- そこで「末尾コール最適化の後」の図のように，関数`A`中の`call`命令を
  無条件ジャンプ命令 `jmp`に書き換えて，関数`B`からは(`A`を経由せず)
  直接，`main`関数のリターンするように書き換えて無駄なリターンを省くことができます．
  これが末尾コール最適化です．
- その結果，関数`B`のリターンアドレスは，関数`A`中の`call`命令の次のアドレス
  (次の命令❷)ではなく，関数`main`中の「次の命令❶」となってしまいました．
 これが戻り番地が通常ではない場合の一例です．
</details>

### デバッグ情報を直接見る

`objdump`，`readelf`，`llvm_dwarfdump`コマンドを使うと，
デバッグ情報の中身を直接見ることができます．

#### `objdump -W`

デバッグ情報には例えば，以下のものがあります

  - デバッグ情報 (`.debug_info`)
  - 行情報 (`.debug_line`)
  - アドレス情報 (`.debug_aranges`)
  - フレーム情報 (`.eh_frame`)
  - 省略情報 (`.debug_abbrev`)

  `objdump -W add5.o` とすると，`add5.o`中のデバッグ情報を全て表示します
  `-Wi`， `-Wl`， `-Wr`， `-Wf`，`-Wa`とすると，
  それぞれ，デバッグ情報，行情報，アドレス情報，フレーム情報，
  省略情報だけを表示できます．
  
```bash
$ objdump -W add5.o | less
add5.o:     file format elf64-x86-64

Contents of the .debug_info section:

  Compilation Unit @ offset 0x0:
   Length:        0x62 (32-bit)
   Version:       5
   Unit Type:     DW_UT_compile (1)
   Abbrev Offset: 0x0
   Pointer Size:  8
 <0><c>: Abbrev Number: 1 (DW_TAG_compile_unit)
    <d>   DW_AT_producer    : (indirect string， offset: 0x5): GNU C17 11.3.0 -mtune=generic -march=x86-64 -g -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
    <11>   DW_AT_language    : 29       (C11)
    <12>   DW_AT_name        : (indirect line string， offset: 0x5): add5.c
(以下略)
```

上記の出力例では例えば「ファイル名`add5.c`を省略番号`1`とします」という情報を含んでいます（詳細は省略し．
**コンパイル単位** (compile unit)とはファイルのことです．

例えば，以下の部分は
仮引数の情報として「変数名は❻`n`，
❷`add5.c`の❸1行目❹15カラム目で宣言されていて，
型は❺`<0x5e>`を見てね．変数の場所は❻`(DW_OP_fbreg: -20)`」となってます．

```
<2><50>: Abbrev Number: 3 (DW_TAG_formal_parameter)
    <51>   DW_AT_name        : ❶ n
    <53>   DW_AT_decl_file   : ❷ 1
    <54>   DW_AT_decl_line   : ❸ 1
    <55>   DW_AT_decl_column : ❹ 15
    <56>   DW_AT_type        : ❺ <0x5e>
    <5a>   DW_AT_location    : 2 byte block: 91 6c ❻ (DW_OP_fbreg: -20)
```

<details>
<summary>
❻DW_OP_fbreg: -20とは
</summary>

「CFA (canonical frame address)から -20バイトのオフセットの位置」を意味しています．
CFAはDWARFデバッグ情報が定める仮想的なレジスタでCPUごとに異なります．
x86-64の場合は「`call`命令を実行する直前の`%rsp`の値」なので，以下になります．
(`call`命令が戻り番地をスタックにプッシュすることを思い出しましょう)．
引数`n`(下図で赤い部分)の先頭アドレスは，
CFAからちょうど-20バイトの場所にあることが確認できました．
 
<img src="figs/stack-layout-CFA.svg" height="400px" id="fig:stack-layout">
 
[-fomit-frame-pointer](./2-asm-intro.md#-fomit-frame-pointer)でコンパイルされていなければ，
(通常は関数の先頭で`push %rbp`するので)以下の式が成り立ちます．
 
```math
CFA == %rbp + 16
```
 
なお，`fbreg` は frame base registerの略だと思います．
</details>

<details>
<summary>
Abbrev Number (省略番号)とは
</summary>

例えば，以下のDIE（[デバッグ情報の部品](#DIE)）で Abbrev Number は ❶4となっています．
 
```bash
$ objdump -Wi add5.o
(一部略)
<1><5e>: Abbrev Number: ❶4 (DW_TAG_base_type)
    <5f>   DW_AT_byte_size   : 4
    <60>   DW_AT_encoding    : 5         (signed)
    <61>   DW_AT_name        : int
```

`objdump -Wa`で`.debug_abbrev`を表示すると4番目のエントリは
以下となっています．つまり，

- ❷4番のAbbrev Number (省略番号)を持つDIEは ❸DW_TAG_base_type である
- DW_TAG_base_typeには例えば，❹変数名の情報があり，その型は❺DW_FORM_stringである

と分かります．

```bash
$ objdump -Wa add5.o
(一部略)
❷4 ❸DW_TAG_base_type    [no children]
    DW_AT_byte_size    DW_FORM_data1
    DW_AT_encoding     DW_FORM_data1
  ❹DW_AT_name       ❺DW_FORM_string
    DW_AT value: 0     DW_FORM value: 0
```
 
要するに`.debug_abbrev`の情報は`.debug_info`のメタ情報(型情報)であり，
この場合，4という数字を保持するだけで，
「このDIEはDW_TAG_base_typeである．その内容は…(以下略)」
という情報を持てるのです．

これによりサイズの圧縮が可能になっています．
`objdump -W`はある程度は散っている情報をまとめて表示していて親切です．
</details>

<details>
<summary>
LEB128とは
</summary>

LEB128 (little endian base 128)は任意の大きさの整数を扱える
可変長の符号化方式です．直感的にはLEB128はUTF-8の整数版です．

LEB128はDWARFやWebAssemblyなどで使われています．
(ですので，DWARFデバッグ情報にはLEB128の符号化が使われている箇所があります．
デバッグ情報の16進ダンプを解析する際は注意しましょう)．

LEB128には符号ありと符号なしの2種類がありますが，以下では符号なしで説明します．
 
ここでは123456を符号なしLEB128形式に変換します．
結果は最下位バイトから，`0xC0`，`0xC4`，`0x07`の3バイトになります．
まず`bc`コマンドで2進数にします❶．
 
```bash
$ bc
obase=2
123456
❶ 11110001001000000
```

次に以下のステップを踏みます．
 
<form class="tab-wrap">
    <input id="LEB128-1" type="radio" name="TAB" class="tab-switch" checked="checked" />
    <label class="tab-label" for="LEB128-1">ステップ1</label>
    <div class="tab-content">
    	 <img src="figs/LEB128-1.svg" height="70px" id="fig:LEB128-1">
    </div>
    <input id="LEB128-2" type="radio" name="TAB" class="tab-switch" />
    <label class="tab-label" for="LEB128-2">ステップ2</label>
    <div class="tab-content">
    	 <img src="figs/LEB128-2.svg" height="70px" id="fig:LEB128-2">
    </div>
    <input id="LEB128-3" type="radio" name="TAB" class="tab-switch" />
    <label class="tab-label" for="LEB128-3">ステップ3</label>
    <div class="tab-content">
    	 <img src="figs/LEB128-3.svg" height="70px" id="fig:LEB128-3">
    </div>
    <input id="LEB128-4" type="radio" name="TAB" class="tab-switch" />
    <label class="tab-label" for="LEB128-4">ステップ4</label>
    <div class="tab-content">
    	 <img src="figs/LEB128-4.svg" height="85px" id="fig:LEB128-4">
    </div>
</form>
 
ステップ4の結果を`bc`コマンドで16進数にします❷．


```bash
$ bc
obase=16
ibase=2
000001111100010011000000
❷ 7C4C0
```

結果の16進数❷`0x7C4C0` を1バイトごとに最下位バイトから出力すると，
最終的な結果は`0xC0`，`0xC4`，`0x07`となります．
LEB128の最上位バイトの最上位ビットは必ず0で，
それ以外のバイトはの最上位ビットは1なので，
サイズ情報がなくても，
元の整数に戻す際，どのバイトまで処理すればよいかが分かります．
</details>


型の情報`<0x5e>`は以下にありました．
「サイズは❼ 4バイト，❽符号あり，型名は❾`int`」です．

```
<1><5e>: Abbrev Number: 4 (DW_TAG_base_type)
    <5f>   DW_AT_byte_size   : ❼ 4
    <60>   DW_AT_encoding    : 5        ❽ (signed)
    <61>   DW_AT_name        : ❾ int
```

<div id="DIE">

上記の`.debug_info`中の情報である，
DW_TAG_formal_parameterやDW_TAG_base_typeなどは
DIE (debug information entry)というデバッグ情報の単位の1つです．
DIEは全体で木構造になっています．
</div>

<img src="figs/DIE-tree.svg" height="150px" id="fig:DIE-tree">

またデバッグ情報情報があちこちに散っています．
例えば，❷「ファイル1」の情報はどこにあるかというと

```
    <53> ❷ DW_AT_decl_file   : 1
```

行情報にありました．
以下でエントリ1の情報を見ると，`add5.c`と分かりました．

```bash
$ objdump -Wl add5.o | less
(中略)
The File Name Table (offset 0x2c, lines 2, columns 2):
  Entry Dir     Name
  0     0       (indirect line string, offset: 0x11): add5.c
  1     0       (indirect line string, offset: 0x18): add5.c
```

#### `readelf`

`readelf`コマンドでも`objdump`と同様にDWARFデバッグ情報を表示できます．
以下は実行例です．

```bash
$ readelf -wi ./add5.o
Contents of the .debug_info section:

  Compilation Unit @ offset 0x0:
   Length:        0x62 (32-bit)
   Version:       5
   Unit Type:     DW_UT_compile (1)
   Abbrev Offset: 0x0
   Pointer Size:  8
 <0><c>: Abbrev Number: 1 (DW_TAG_compile_unit)
    <d>   DW_AT_producer    : (indirect string, offset: 0x5): GNU C17 11.3.0 -mtune=generic -march=x86-64 -g -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
    <11>   DW_AT_language    : 29       (C11)
    <12>   DW_AT_name        : (indirect line string, offset: 0x5): add5.c
    <16>   DW_AT_comp_dir    : (indirect line string, offset: 0x0): /tmp
    <1a>   DW_AT_low_pc      : 0x0
    <22>   DW_AT_high_pc     : 0x13
    <2a>   DW_AT_stmt_list   : 0x0
(以下略)
```

## メモリマップを見る

### `pmap`コマンドでメモリマップを見る

`pmap`コマンドを使うと，
実行中のプログラム(プロセス)がどのメモリ領域を使用しているか
(メモリマップ)を調べられます．
(この出力は`/proc`ファイルシステムの `/proc/プロセス番号/maps`の内容から作られています)．


```bash
$ cat 
❶ ^Z   
[1]+  Stopped                 cat
$ ps | egrep cat
❷  7687 pts/0    00:00:00 cat
$ ❸ pmap 7687
7687:   cat
❼000055f74daf2000      8K r---- cat
❼000055f74daf4000     16K r-x-- cat
❼000055f74daf8000      8K r---- cat
❼000055f74dafa000      4K r---- cat
❼000055f74dafb000      4K rw--- cat
000055f74dafc000    132K rw---   [ anon ]
00007f63a7e00000   6628K r---- locale-archive
00007f63a8600000    160K r---- libc.so.6
00007f63a8628000   1620K r-x-- libc.so.6
00007f63a87bd000    352K r---- libc.so.6
00007f63a8815000     16K r---- libc.so.6
00007f63a8819000      8K rw--- libc.so.6
00007f63a881b000     52K rw---   [ anon ]
00007f63a8829000    148K rw---   [ anon ]
00007f63a885d000      8K rw---   [ anon ]
00007f63a885f000      8K r---- ld-linux-x86-64.so.2
00007f63a8861000    168K r-x-- ld-linux-x86-64.so.2
00007f63a888b000     44K r---- ld-linux-x86-64.so.2
00007f63a8897000      8K r---- ld-linux-x86-64.so.2
00007f63a8899000      8K rw--- ld-linux-x86-64.so.2
❹ 00007fff86f9f000 132K ❺rw---   ❻[ stack ]
00007fff86ff8000     16K r----   [ anon ]
00007fff86ffc000      8K r-x--   [ anon ]
ffffffffff600000      4K --x--   [ anon ]
 total             9560K
$ fg
❽ ^D
```

-  まず `cat`コマンドを起動します．ファイル名を指定していないので，
  標準入力からの入力待ちになります．
  ここで❶ ctrl-z を入力して，`cat`コマンドの実行を中断 (suspend)します．
  `pmap`コマンドは実行中のプロセスにしか実行できないため，
  `cat`コマンドが実行中のまま終了しないように，こうしています．
- 次に`ps`コマンドで`cat`コマンドのプロセス番号を調べます．
  ❷7687がプロセス番号と分かりました．
- ❸プロセス番号7687を引数として`pmap`コマンドを実行します．
- 出力の各行が使用中のメモリ領域の情報を示しています．例えば，❹の行は次を意味しています．

  `
  ❹ 00007fff86f9f000    132K ❺rw---   ❻[ stack ]
  `

  - ❹アドレス`00007fff86f9f000'からサイズ132KBの領域を使用している．
  - このメモリ領域の❻アクセス権限は読み書きが可能で，実行は不可．
     - `r` 読み込み可能
     - `w` 書き込み可能
     - `x` 実行可能
  - このメモリ領域は❻スタックとして使用している

- `cat`コマンド自身は以下の5つのメモリ領域を使用しています．

  ```bash
  ❼000055f74daf2000      8K r---- cat
  ❼000055f74daf4000     16K r-x-- cat
  ❼000055f74daf8000      8K r---- cat
  ❼000055f74dafa000      4K r---- cat
  ❼000055f74dafb000      4K rw--- cat
  ```

  - アクセス権限が `r-x--`のものは，`.text`セクションでしょう．
    (`.text`セクションは通常，実行可能かつ書き込み禁止にするからです)
  - アクセス権限が `rw----`のものは，`.data`セクションでしょう．
    (`.data`セクションは通常，実行禁止かつ書き込み可能にするからです)
  - 残りの3つのアクセス権限が `r----` のものは，`.rodata`セクションなどでしょう．
    (詳細は調べていません)
  - 使用しているサイズが4KBの倍数なのは，x86-64でよくある
    **ページ**(page)サイズが4KBだからです．
    (ページとは仮想記憶方式の1つであるページングで使われる，
    固定長(例えば4KB)に区切ったメモリ領域のことです)．
    プロセスは`mmap`システムコールを使って，OSからページ単位でメモリを割り当ててもらい，その際にページごとにアクセス権限を設定できます．


- 最後に❽で，中断していた`cat`コマンドを`fg`コマンドで実行を再開し，
  `ctrl-D`を入力して`cat`コマンドの実行を終了しています．

### `gdb`でメモリマップを見る

`gdb`でもメモリマップを見ることができます

```bash
$ gdb /usr/bin/cat
(gdb) r
ctrl-z
Program received signal SIGTSTP, Stopped (user).
(gdb) info proc map
process 7821
Mapped address spaces:

          Start Addr           End Addr       Size     Offset  Perms  objfile
      0x555555554000     0x555555556000     0x2000        0x0  r--p   /usr/bin/cat
      0x555555556000     0x55555555a000     0x4000     0x2000 ❶r-xp   /usr/bin/cat
~      0x55555555a000     0x55555555c000     0x2000     0x6000  r--p   /usr/bin/cat
~      0x55555555c000     0x55555555d000     0x1000     0x7000  r--p   /usr/bin/cat
~      0x55555555d000     0x55555555e000     0x1000     0x8000  rw-p   /usr/bin/cat
~      0x55555555e000     0x55555557f000    0x21000        0x0  rw-p   [heap]
~      0x7ffff7400000     0x7ffff7a79000   0x679000        0x0  r--p   /usr/lib/locale/locale-archive
~      0x7ffff7c00000     0x7ffff7c28000    0x28000        0x0  r--p   /usr/lib/x86_64-linux-gnu/libc.so.6
~      0x7ffff7c28000     0x7ffff7dbd000   0x195000    0x28000  r-xp   /usr/lib/x86_64-linux-gnu/libc.so.6
~      0x7ffff7dbd000     0x7ffff7e15000    0x58000   0x1bd000  r--p   /usr/lib/x86_64-linux-gnu/libc.so.6
~      0x7ffff7e15000     0x7ffff7e19000     0x4000   0x214000  r--p   /usr/lib/x86_64-linux-gnu/libc.so.6
~      0x7ffff7e19000     0x7ffff7e1b000     0x2000   0x218000  rw-p   /usr/lib/x86_64-linux-gnu/libc.so.6
~      0x7ffff7e1b000     0x7ffff7e28000     0xd000        0x0  rw-p   
~      0x7ffff7f87000     0x7ffff7fac000    0x25000        0x0  rw-p   
~      0x7ffff7fbb000     0x7ffff7fbd000     0x2000        0x0  rw-p   
~      0x7ffff7fbd000     0x7ffff7fc1000     0x4000        0x0  r--p   [vvar]
~      0x7ffff7fc1000     0x7ffff7fc3000     0x2000        0x0  r-xp   [vdso]
~      0x7ffff7fc3000     0x7ffff7fc5000     0x2000        0x0  r--p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
~      0x7ffff7fc5000     0x7ffff7fef000    0x2a000     0x2000  r-xp   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
~      0x7ffff7fef000     0x7ffff7ffa000     0xb000    0x2c000  r--p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
~      0x7ffff7ffb000     0x7ffff7ffd000     0x2000    0x37000  r--p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
~      0x7ffff7ffd000     0x7ffff7fff000     0x2000    0x39000  rw-p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
~      0x7ffffffde000     0x7ffffffff000    0x21000        0x0  rw-p   [stack]
~  0xffffffffff600000 0xffffffffff601000     0x1000        0x0  --xp   [vsyscall]
```

<details>
<summary>
アクセス権限rwxpの❶pとは
</summary>

`mmap`でメモリ領域をマップする際に，
フラグとして`MAP_PRIVATE`を指定すると`p`，
`MAP_SHARED`を指定すると`s`と表示されます．

- `MAP_PRIVATE` マップした領域への変更はプロセス間で共有されません．
   このマップは**copy-on-write**なので，書き込まれるまで自分専用のコピーは発生せず，共有されます．
   (copy-on-writeとは「書き込みが起こるまでコピーを遅延する」というテクニックです)．
   
- `MAP_SHARED` マップした領域への変更はプロセス間で共有されます．
   すなわちマップした領域に書き込みを行うと，
   その変更は他のプロセスにも見えます．
   ただし，`msync`を使う必要があります．

❶`.text`セクションの共有設定も`p`となっています．
これは`.text`セクションも`mmap`の`MAP_PRIVATE`でマップしているからです．
動的リンクした実行可能ファイルの`.text`セクションは
物理メモリ上で共有されていますが，
その共有と`MAP_SHARED`は関係ないのです．

<!--
ちなみに，そのプロセスが`mmap`で`MAP_SHARED`なマップをすれば，
表示が`s`になります(自分でやってみて確かめました)．

strace して .text を MAP_PRIVATE　してるのを確かめようとしたけど
よくわからんかった．
$ strace /lib64/ld-linux-x86-64.so.2 /usr/bin/cat
もやったんだけどね．
-->

</details>

## 再配置情報 {#relocation}

### 再配置情報の概要

**再配置情報**(relocation information)とは「後でアドレス調整する時のために，
機械語命令中のどの場所をどんな方法で書き換えればよいか」を表す情報です．
オブジェクトファイル`*.o`は一般的に再配置情報を含んでいます．

```C
{{#include asm/reloc-main.c}}
```

```C
{{#include asm/reloc-sub.c}}
```

例えば，上の[`reloc-main.c`](./asm/reloc-main.c)と
[`reloc-sub.c`](./asm/reloc-sub.c)を見て下さい．
`reloc-main.c`中で参照している変数`x`の実体は`reloc-main.c`中には無く，
実体は`reloc-sub.c`中にあります．

<img src="figs/reloc-overview.svg" height="170px" id="fig:reloc-overview">

ですので，[`reloc-main.s`](./asm/reloc-main.s)中の
`movq x(%rip), %eax`をアセンブルして`reloc-main.o`を作っても，
この時点では`x`のアドレスが不明なので，**仮のアドレス**(上図では`00 00 00 00`)
にするしかありません．
そこで，この`movq x(%rip), %eax`命令に対する**再配置情報**として
「この命令の2バイト目から4バイトを4バイト長の`%rip`相対アドレスで埋める」
という情報(`R_X86_64_PC32`，[後述](#R_X86_64_PC32))を
`reloc-main.o`中に保持しておき，リンク時に正しいアドレスを埋め込むのです．

<img src="figs/reloc-overview2.svg" height="300px" id="fig:reloc-overview2">

```
$ gcc -c reloc-main.c
$ gcc -c reloc-sub.c
$ gcc reloc-main.o reloc-sub.o
```

<details>
<summary>
なんでgccを3回?
</summary>

通常は`gcc reloc-main.c reloc-sub.c`と，`gcc`を一回実行して
`a.out`を作ります．が，ここでは`reloc-main.o`の中の再配置情報を
見たいので，わざわざ別々に`reloc-main.o`と`reloc-sub.o`を作り，
最後にリンクして`a.out`を作っています．
</details>

`reloc-main.o`と`reloc-sub.o`をリンクして`a.out`を作ると，
(様々な`*.o`中のセクションを一列に並べることで)
変数`x`のアドレスが`0x4010`に決まり，
上図の「次の命令」のアドレスも`0x1157`に決まりました．
仮のアドレスに埋めたかったのは，`%rip`相対番地でしたので，
`0x4010-0x1157=0x2EB9`と計算した`0x2EB9`番地を仮のアドレスの部分に埋めました．
これが再配置です．

<details>
<summary>
様々な*.o中のセクションを一列に並べることで，とは
</summary>

<br/>
<img src="figs/reloc-overview4.svg" height="200px" id="fig:reloc-overview4">

例えば上図で`foo2.o`中の変数`x`のアドレスは仮アドレス`0x1000`ですが，
`foo1.o`と`foo2.o`中のセクションを1列に並べると，
リンク後は「`a.out`の先頭アドレスが(例えば)`0x4000`なので，先頭から数えると，
(`0x4000 + 0x0500 + 0x1000 = 0x5500`という計算をして)
変数`x`のアドレスは`0x5500`に決まりますよね」という話です．
</details>

### `objdump -dr` で再配置情報を見てみる{#objdump-dr}

```
$ gcc -g -c reloc-main.c
$ objdump -dr reloc-main.o
./reloc-main.o:     file format elf64-x86-64
Disassembly of section .text:

0000000000000000 <main>:
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	48 89 e5             	mov    %rsp,%rbp
   8:	8b 05 ❶ 00 00 00 00    mov    0x0(%rip),%eax        # e <main+0xe>
		❷ a: R_X86_64_PC32	x-0x4
   e:	89 c6                	mov    %eax,%esi
  10:	48 8d 05 ❸ 00 00 00 00 	lea    0x0(%rip),%rax        # 17 <main+0x17>
		❹ 13: R_X86_64_PC32	.rodata-0x4
  17:	48 89 c7             	mov    %rax,%rdi
  1a:	b8 00 00 00 00       	mov    $0x0,%eax
  1f:	e8 00 00 00 00       	call   24 <main+0x24>
			20: R_X86_64_PLT32	printf-0x4
  24:	b8 00 00 00 00       	mov    $0x0,%eax
  29:	5d                   	pop    %rbp
  2a:	c3                   	ret    
```

[前節](#再配置情報の概要)の説明を，実際に再配置情報を見ることで確かめます．
上の実行例は`objdump -dr`で`reloc-main.o`の逆アセンブルの結果と
再配置情報の両方を表示させたものです．

- ❶を見ると[図](#fig:reloc-overview)の通り，仮のアドレス `00 00 00 00`
  を確認できます．
- <span id="R_X86_64_PC32">❷の`a: R_X86_64_PC32 x-0x4`が再配置情報です．</span>
  - `a`は仮のアドレスを書き換える場所(`.text`セクションの先頭からのオフセット)です．
    命令`mov 0x0(%rip), %eax`の先頭のオフセットが`0x8`なので，
    `0x8`に`2`を足した値が`0xa`となっています
    (この`mov`命令の最初の2バイトはオペコード)．
  - `R_X86_64_PC32`は再配置の方法を表しています．
    「`%rip`相対アドレスで4バイト(32ビット)としてアドレスを埋める」ことを意味しています．
    (PCはプログラムカウンタ，つまり`%rip`を使うことを意味しています)．
  - `x-0x4`は「変数`x`のアドレスを使って埋める値を計算せよ．
    その際に`-0x4`を足して調整せよ」を意味しています．

<details>
<summary>
-4はどう使うのか
</summary>

`R_X86_64_PC32`は[System V ABI](https://wiki.osdev.org/System_V_ABI)が
定めており，埋めるアドレスのサイズは4バイト(32ビット)，
埋めるアドレスの計算方法は`S + A - P`と定めています．

- `S` はそのシンボルのアドレス (上の例では`0x4010`)
- `A` は調整用の値 (addend と呼びます．上の例では`-4`)
- `P` は仮アドレスを書き換える場所 (上の例では`0x1157 - 4`番地)

なので，計算すると

```
0x4010 + (-4) - (0x1157 - 4) = 0x2EB9
```

となります．

</details>

- ❸は"%d\n"という文字列の仮アドレス，❹はその仮アドレスの再配置情報です．
  ❶❷と同様です．

### `readelf -r`で再配置情報を見てみる

```
$ readelf -r reloc-main.o | less
Relocation section '.rela.text' at offset 0x5b0 contains 3 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
00000000000a  000a00000002 R_X86_64_PC32     0000000000000000 x - 4
000000000013  000300000002 R_X86_64_PC32     0000000000000000 .rodata - 4
000000000020  000b00000004 R_X86_64_PLT32    0000000000000000 printf - 4
(略)
```

`readelf -r`でも`objdump -dr`と同様の結果が得られます．

### PLTの再配置情報

`printf`の再配置情報も見てみましょう．

<img src="figs/reloc-overview3.svg" height="300px" id="fig:reloc-overview3">

```
$ objdump -dr ./reloc-main.o
./reloc-main.o:     file format elf64-x86-64
Disassembly of section .text:
0000000000000000 <main>:
   0:   f3 0f 1e fa             endbr64 
   4:   55                      push   %rbp
   5:   48 89 e5                mov    %rsp,%rbp
   8:   8b 05 00 00 00 00       mov    0x0(%rip),%eax        # e <main+0xe>
                        a: R_X86_64_PC32        x-0x4
   e:   89 c6                   mov    %eax,%esi
  10:   48 8d 05 00 00 00 00    lea    0x0(%rip),%rax        # 17 <main+0x17>
                        13: R_X86_64_PC32       .rodata-0x4
  17:   48 89 c7                mov    %rax,%rdi
  1a:   b8 00 00 00 00          mov    $0x0,%eax
  1f:   e8 ❶ 00 00 00 00       call   24 <main+0x24>
             ❷ 20: R_X86_64_PLT32      printf-0x4
  24:   b8 00 00 00 00          mov    $0x0,%eax
  29:   5d                      pop    %rbp
  2a:   c3                      ret    
```

```
$ objdump -d ./a.out
0000000000001149 <main>:
    1149:       f3 0f 1e fa             endbr64 
    114d:       55                      push   %rbp
    114e:       48 89 e5                mov    %rsp,%rbp
    1151:       8b 05 b9 2e 00 00       mov    0x2eb9(%rip),%eax        # 4010 <x>
    1157:       89 c6                   mov    %eax,%esi
    1159:       48 8d 05 a4 0e 00 00    lea    0xea4(%rip),%rax        # 2004 <_IO_stdin_used+0x4>
    1160:       48 89 c7                mov    %rax,%rdi
    1163:       b8 00 00 00 00          mov    $0x0,%eax
    1168:     ❸e8 e3 fe ff ff          call   1050 <printf@plt>
    116d:       b8 00 00 00 00          mov    $0x0,%eax
    1172:       5d                      pop    %rbp
    1173:       c3                      ret    
```

[先程の`x`](#objdump-dr)の場合とほぼ同じです．

- ❶を見ると[図](#fig:reloc-overview3)の左側の通り，仮のアドレス `00 00 00 00`
  を確認できます．
- ❷の`20: R_X86_64_PLT32 printf-0x4`が再配置情報です．
  - `20`は仮のアドレスを書き換える場所(オフセット)です．
  - `R_X86_64_PLT32`は再配置の方法を表しており
    「`printf@plt`への`%rip`相対アドレス (4バイト(32ビット))を埋める」ことを意味しています．
  - `printf-0x4`は「変数`printf@plt`のアドレスを使って埋める値を計算せよ．
    その際に`-0x4`を足して調整せよ」を意味しています．

<details>
<summary>
-4はどう使うのか
</summary>

`R_X86_64_PLT32`は[System V ABI](https://wiki.osdev.org/System_V_ABI)が
定めており，埋めるアドレスのサイズは4バイト(32ビット)，
埋めるアドレスの計算方法は`L + A - P`と定めています．

- `L` はそのシンボルのPLTエントリのアドレス (上の例では`printf@plt`のアドレス`0x1050`)
- `A` は調整用のaddend (上の例では`-4`)
- `P` は仮アドレスを書き換える場所 (上の例では`0x116D - 4`番地)

なので，計算すると

```
0x1050 + (-4) - (0x116D - 4) = -0x11D = 0xFFFFFEE3
```

となります．

</details>

- `a.out`中では「次の命令」が`0x116D`番地，`printf@plt`が`0x1050`番地と決まったので，`0x1050 - 0x116D = -0x11D = 0xFFFFFEE3`番地が
❸の部分に埋め込まれました．

[ここ](#GOT-PLT)でも説明した通り，
`printf`の実体はCライブラリの中にあり，
(`gcc`のデフォルト動作である)[動的リンク](#動的リンク)の場合，
PLTとGOTの仕組みを使って，`printf`を呼び出します．
これは[先程の`x`](#objdump-dr)の場合は
「(`main`関数中の)次の命令と変数`x`の相対アドレスは固定で決まる」のに対して，
`printf`の場合は固定で決まらないからです
(Cライブラリが実行時に何番地にロードされるか不明だから)．

<img src="figs/plt-printf2.svg" height="300px" id="fig:plt-printf2">

そこで，

- `main`関数中では(`printf`を直接呼ぶのではなく)，
  (`printf`のための踏み台である)`printf@plt`を呼び出す．
- `printf@plt`はGOT領域に実行時に書き込まれる`printf`のアドレスを使い，
  間接ジャンプ (上図では`bnd jmp *0x2f75(%rip)`)して，
  本物の`printf`を呼び出す．

という仕組みになっています．

<!--
どの関数を動的リンクすべきかの情報を，動的リンカに引数として
渡すために必要だったけど，今は渡してないように見える．
(`main`関数が`printf@plt`を呼ぶのではなく，
直接`call *0x2f75(%rip)`すればいいんじゃね？と言われると，
私もそれでいいじゃん，と思ってしまいます．
`ltrace`コマンドがPLTエントリをフックして実装している，などの利点があるのは
分かりますが，それ以外に理由はあるのでしょうか．
ご存知の方はぜひ教えてください．)
-->

## ABI と API {#ABI}

ABIとAPIはどちらも**互換性**のための規格(お約束)ですが，
対象がそれぞれ，**バイナリ**，**ソースコード**，と異なります．

### ABI

- ABI = Application Binary Interface
- **バイナリコード**のためのインタフェース規格．
- 同じABIをサポートするシステム上では**再コンパイル無し**で
  同じバイナリを使ったり実行できる．
- ABIはコーリングコンベンション(関数呼び出し規約, calling convention)，
  バイトオーダ，アラインメント，バイナリ形式などを定める
- Linux AMD64のABI は[System V ABI (AMD64)](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build)

### API

- API = Application Programming Interface
- **ソースコード**のためのインタフェース規格
- 同じAPIをサポートするシステム上では**再コンパイルすれば**
  同じソースコードを実行できる．
- 例えば，POSIXはUNIXのAPIであり，LinuxはPOSIXにほぼ準拠している．  
  POSIXはシステムコール，ライブラリ関数，マクロなどの形式や意味を定めている
  - POSIXは[ここ](https://unixism.net/2020/07/getting-a-pdf-version-of-the-posix-standard-document/)に書いてあるとおり，[opengroup.org](https://www.opengroup.org/)に登録することで無料で入手可能

<!--
## セクションの抽出と注入

### 
https://www.baeldung.com/linux/file-elf-extract-raw-contents

https://stackoverflow.com/questions/1088128/adding-section-to-elf-file
-->
