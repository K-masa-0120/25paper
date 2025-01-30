= 実験結果と考察
//それぞれの比較じゃなくて、１つのグラフに対して何に着目すべきかを書く。
== 概要
本章では、実験1および実験2の結果について、各手法ごとの結果の特徴を整理し、それらを比較・考察する。各手法の結果については、ホップ数、移動時間、完全一致回数、部分一致回数の推移を示すグラフおよび表を用い、それぞれの挙動について分析する。

== 実験1の結果
実験1の環境における正規化入力の結果を@fig:51 と@tbl:5-1 、モジュロ演算入力の結果を@fig:52 と@tbl:5-2、インデックス指定値入力の結果を@fig:53 と@tbl:5-3、従来のDQNモデルの結果を@fig:54 と@tbl:5-4 に示す。

また、表に示す数値のうち、総移動時間は単位時間の累計であり、経路一致は一致の回数である。また、完全一致と部分一致は重複した累計で表示されている。

=== 正規化
#figure(
  caption:[実験1、正規化入力のグラフ],
  image("../img/5-1.png" )
)<51>
#linebreak()
#figure(
  caption: [実験1、正規化入力の結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [91696],
    [完全一致＃1], [1557],
    [完全一致＃2], [1643],
    [完全一致＃3], [1521],
    [部分一致＃1], [1687],
    [部分一致＃2], [1742],
    [部分一致＃3], [1621],
    )
)<5-1>
#linebreak()

@fig:51 より、カウンター値の正規化を入力に取り入れた場合は1万カウント前後でホップ数と移動時間の安定が見られ、学習の収束が始まっている。

また、周期が変化したタイミングでルート取りが変化しており、最終的には@tbl:5-1 からも分かるように、想定された経路を同等の頻度で経由している。これは特定の経路に依存せず、複数の状態に対応できていることが分かる。


=== モジュロ演算
#figure(
  caption:[実験1、モジュロ演算入力のグラフ],
  image("../img/5-2.png")
)<52>
#linebreak()
#figure(
  caption: [実験1、モジュロ演算入力の結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [93396],
    [完全一致＃1], [1598],
    [完全一致＃2], [1614],
    [完全一致＃3], [1483],
    [部分一致＃1], [1731],
    [部分一致＃2], [1719],
    [部分一致＃3], [1599],
    )   
)<5-2>
#linebreak()

@fig:52 が示す、モジュロ演算を入力に取り入れた場合の結果では、1万2千カウント近辺からホップ数、移動時間が安定し始めている。

また、@fig:52 の一致経路のグラフと@tbl:5-2 より、特定の経路に偏らず、満遍なく辿っているため、この手法においても周期的な環境に適応した学習ができていることが分かる。

=== インデックス指定値
#figure(
  caption:[実験1、インデックス指定値入力のグラフ],
  image("../img/5-3.png")
)<53>
#linebreak()
#figure(
  caption: [実験1、インデックス指定値入力の結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [92529],
    [完全一致＃1], [1592],
    [完全一致＃2], [1629],
    [完全一致＃3], [1489],
    [部分一致＃1], [1721],
    [部分一致＃2], [1737],
    [部分一致＃3], [1583],
    )
)<5-3>
#linebreak()

@fig:53 が示す、インデックス指定値を入力に取り入れた場合の結果では、1万5千カウント近辺からホップ数、移動時間が安定し始めている。

この手法においても、@tbl:5-3 から分かるようにとある周期の環境に依存することなく学習が環境に対して適応していることが分かる。

=== 従来DQN
#figure(
  caption:[実験1、従来DQNのグラフ],
  image("../img/5-4.png")
)<54>
#linebreak()
#figure(
  caption: [実験1、従来DQNの結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [123740],
    [完全一致＃1], [1248],
    [完全一致＃2], [1397],
    [完全一致＃3], [1152],
    [部分一致＃1], [1713],
    [部分一致＃2], [1862],
    [部分一致＃3], [1623],
    )
)<5-4>
#linebreak()

@fig:54 が示すように、従来DQNモデルでは6万カウント経過後にも収束が遅れ、学習が長時間続いていることが分かる。それぞれの経路を選択し始めるのも5万カウント近辺からであり、@tbl:5-4 から部分一致の回数が多くなっていることから、環境への適応に時間がかかっていることが分かる。

=== 考察
それぞれの手法を比較した際、正規化、モジュロ演算、インデックス指定、従来DQNの順で学習が安定、収束している。

総移動時間を比較した際、提案手法(@tbl:5-1 、@tbl:5-2 、@tbl:5-3)では9万カウント前半で学習を終えたが、従来DQN(@tbl:5-4)では12万カウントを越しているため、提案手法が環境に対して迅速な学習ができていると考えられる。

完全一致、部分一致の指標から比較した際、正規化入力(@fig:51)及びモジュロ演算入力(@fig:52)に対してインデックス指定値入力(@fig:53)の方が部分一致の回数の比率が多く、完全一致の数値に比較的ばらつきが見える。この挙動はインデックス指定値入力の学習では環境の周期変化に大きく依存した挙動であると考えられる。

また、今環境においては正規化入力のモデルの学習が安定した挙動を示し、3つの提案手法のうち優位な適応性を持つことが確認できたが、正規化の入力は長期的に安定した学習の実現が見込まれ、モジュロ演算の入力とインデックス指定値の入力は環境変化に機敏な反応を示すことが考えられる。

== 実験2の結果

実験2の環境における正規化入力の結果を@fig:55 と@tbl:5-5、モジュロ演算入力の結果を@fig:56 と@tbl:5-6、インデックス指定値入力の結果を@fig:57 と@tbl:5-7、従来のDQNモデルの結果を@fig:58 と@tbl:5-8 に示す。

=== 正規化
#figure(
  caption:[実験2、正規化入力のグラフ],
  image("../img/5-5.png")
)<55>
#linebreak()
#figure(
  caption: [実験2、正規化入力の結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [528182],
    [完全一致＃1], [1461],
    [完全一致＃2], [2751],
    [完全一致＃3], [940],
    [部分一致＃1], [2960],
    [部分一致＃2], [4838],
    [部分一致＃3], [2475],
    )
)<5-5>
#linebreak()

正規化入力は@fig:55 を見ると、30万カウント近辺から安定、収束が見込まれるが、20万カウント(長周期の2回目の変化)から収束に向かってホップ数と移動時間が減少していることが見て取れる。

@tbl:5-5 より、経路の一致に関してはばらつきが見られるものの、@fig:55 の経路一致のグラフから完全一致の回数は短周期の変化よりも長周期の変化に基づいた対応をし、部分一致では完全一致と比較して短周期の変化に反応していることが分かる。



=== モジュロ演算
#figure(
  caption:[実験2、モジュロ演算入力のグラフ],
  image("../img/5-6.png")
)<56>
#linebreak()
#figure(
  caption: [実験2、モジュロ演算入力の結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [645701],
    [完全一致＃1], [1209],
    [完全一致＃2], [1924],
    [完全一致＃3], [1578],
    [部分一致＃1], [3828],
    [部分一致＃2], [3945],
    [部分一致＃3], [2664],
    )
)<5-6>
#linebreak()

モジュロ演算の入力は@fig:56 より、40万カウント付近で収束の動向が見られるが、30万カウント(長周期の3回目の変化)から収束に向かい一気にホップ数と移動時間が減少し始めているのが分かる。

@tbl:5-6 及び@fig:56 より、完全一致経路の回数はばらつきが見られるが、部分一致の回数が比較的安定している。周期の変化と照らし合わせると、比較的短周期の変化に反応して経路を選択していることが分かる。

=== インデックス指定値
#figure(
  caption:[実験2、インデックス指定値入力のグラフ],
  image("../img/5-7.png")
)<57>
#linebreak()
#figure(
  caption: [実験2、インデックス指定値入力の結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [514694],
    [完全一致＃1], [1688],
    [完全一致＃2], [2871],
    [完全一致＃3], [681],
    [部分一致＃1], [3392],
    [部分一致＃2], [4833],
    [部分一致＃3], [2036],
    )
)<5-7>
#linebreak()

インデックス指定値の入力は@fig:57 より、35万カウント付近で学習の収束が見込まれる。10万カウントから20万カウントの間で一度収束に近づく挙動を見せたが、30万カウント目の長周期が変化したタイミングでもう一度ホップ数が多くなり、環境の変化に反応していることが分かる。また、この挙動は40万、50万カウントの長周期が変動した際にも見られる。

@tbl:5-7 及び@fig:57 より、一致経路のばらつきは見られ、どちらの周期が変化しても一致回数の増加が少なく、時間が少し経過するまでは最適経路の完全一致を選択できていないことが分かる。

=== 従来DQN
#figure(
  caption:[実験2、従来DQNのグラフ],
  image("../img/5-8.png")
)<58>
#linebreak()
#figure(
  caption: [実験2、従来DQNの結果],
  table(
    columns: 2,
    table.header([計測種類],[カウント]),
    [総移動時間], [5062261],
    [完全一致＃1], [28],
    [完全一致＃2], [0],
    [完全一致＃3], [0],
    [部分一致＃1], [5618],
    [部分一致＃2], [222],
    [部分一致＃3], [461],
    )
)<5-8>
#linebreak()

従来DQNはホップ数に収束が見られず、移動時間に多少の上下はあるものの、学習としては発散してしまっていることが分かる。

=== 考察
それぞれの手法で比較した際、学習の収束においては実験1と同じく正規化、モジュロ演算、インデックス指定の順で安定、収束している。また、従来DQNは学習が発散してしまい、環境に適応できなったことが分かる。これにより、マップが複雑化した状態でも、提案手法が環境の変化を捉えて適した学習を行うことができると考えられる。

完全一致、部分一致の指標では、モジュロ演算入力が他2手法よりも完全一致の選択回数の合計が少なく、周期的な変化に比較的大きな影響を受けていることが分かる。一方、正規化入力は完全一致の回数が比較的多く、安定した経路探索を行えていることが分かる。インデックス指定値入力は他2手法よりも部分一致の回数が多く、特定の経路に固定されずに経路を選択する柔軟な学習を行っていることが考えられる。

本実験においては正規化入力のモデルが最も安定した学習の挙動を示し、3つの提案手法の中で優位な適応性を持つことが確認できた。一方で、インデックス指定値の入力は環境の変化に柔軟に対応する特性を持ち、モジュロ演算の入力は周期変化に対する影響を受けやすいが、適応能力自体は一定程度あることが分かった。このことから、正規化の入力は長期的に安定した学習の実現が見込まれるが、インデックス指定値の入力やモジュロ演算の入力は環境の変化に対してより機敏に反応する可能性がある。


/*それぞれの手法を比較した際、正規化、モジュロ演算、インデックス指定、従来DQNの順で学習が安定、収束している。

総移動時間を比較した際、提案手法(@tbl:5-1 、@tbl:5-2 、@tbl:5-3)では9万カウント前半で学習を終えたが、従来DQN(@tbl:5-4)では12万カウントを越しているため、提案手法が環境に対して迅速な学習ができていると考えられる。

完全一致、部分一致の指標から比較した際、正規化入力(@fig:51)及びモジュロ演算入力(@fig:52)に対してインデックス指定値入力(@fig:53)の方が部分一致の回数の比率が多く、完全一致の数値に比較的ばらつきが見える。この挙動はインデックス指定値入力の学習では環境の周期変化に大きく依存した挙動であると考えられる。

また、今環境においては正規化入力のモデルの学習が安定した挙動を示し、3つの提案手法のうち優位な適応性を持つことが確認できたが、正規化の入力は長期的に安定した学習の実現が見込まれ、モジュロ演算の入力とインデックス指定値の入力は環境変化に機敏な反応を示すことが考えられる。*/

#pagebreak()