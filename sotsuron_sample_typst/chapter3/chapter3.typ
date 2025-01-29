= 原理

== 概要
本章では本研究で用いる複数周期によって変化するシミュレータ環境の設定について説明したのち、提案手法であるカウンターを入力に持つ深層強化学習モデルについての説明をする。

//周期的に変化する環境をシミュレーションするための各種設計やその方法について説明する。

== 環境設定
本節では周期的に変化する環境をシミュレーションするための各種設計について説明する。
=== 複数周期を持つマップ構造
//(混雑度を複数持ったマップ要素の説明。原理の方ではコードの説明はしない。一般化したときのものを各。)
本研究で扱う模擬的な環境をノードとエッジによるグラフ構造で構成する。また、このマップを探索するエージェントは単一のエージェントである。
//数学的グラフという言葉と、自分の理解するものがごっちゃに。だから分かりづらい。
各ノードは隣接ノードとの接続情報や移動時間に関する周期的な特性を保持する構造を持つ。//各エッジは通過するのに要する時間を重みとしてもち、その重みが周期的に変化する。
それぞれのノードは
- 接続しているノード
ノード間の直接的な接続情報を示すもの。//いらない
//周期的な重みの変化は二つの周期の重ね合わせであり…
- 1つ目の周期に依存する移動時間
本研究では比較的長い周期(季節や日付による変動をイメージしたもの)で変動する移動時間を示すもの。以降、長周期変動の移動時間と称する。
- 2つ目の周期に依存する移動時間
本研究では比較的短い周期(ラッシュアワーなど一時的な変動をイメージしたもの)で変動する移動時間を示すもの。以降、短周期変動の移動時間と称する。

の3つの要素を持つ。これらはリスト構造を用いることにより複数の環境を持つマップ構造を構成する。

一例として、n番目のノードは#linebreak()
$n:[["接続しているノード"],["長周期変動の移動時間"],["短周期変動の移動時間"]]$
という構造を取る。この時、接続するノードは必ず1次元の配列だが、移動時間は接続しているノード数によって複数次元のリスト構造を持つ。また、長周期変動の移動時間と短周期変動の移動時間は任意で複数の数値を設定することができ、これを各時間帯における混雑度から起因する移動時間とみなす。
//ここ以下書き直し。具体例より数式的に書くほうがいい。
$ "node"=
  mat(n&:[[m, m'],[[1,4,5],[4,2,1]],[[4,1,2],[2,5,3]]];

  m&:[[n],[[1,4,5]],[[4,1,2]]];

  m'&:[[n],[[4,2,1]],[[2,5,3]]];
  )
$<例>
#linebreak()
#figure(
  image("/img/page3-1.png",height: 200pt,),
  caption: [ノード構造の例]
)<構造>
#linebreak()

@eqt:例 は、本研究で用いるマップ構造定義の一例であり、@fig:構造 はそれをもとに図示したものである。ここに示しているのはn番目のノードからm及びm'の2つのノードへ接続されている場合であり、2方向に接続を持っているので長周期、短周期ともに2次元のリスト構造を持っている。また、移動時間は長周期、短周期それぞれに3パターンが設定されている。加えて、ノード移動は逆方向に関しても同じ移動時間を保持する環境で考慮するため、m及びm'番目のノードはn番目のノードで設定したものと同じ数値の構造を持つ。この形を基本とし、複数のノードをエッジによって結合させ1つのマップ環境として扱う。実験にて利用する詳細なマップ構造は後の4章で言及する。

また、これらの移動時間を利用する際は、移動時間要素はリスト構造を持っているためインデックス番号によって参照、利用される。

=== カウンターを利用した周期的変化//この辺はいいんじゃないの？
//(カウンターによる周期が変化していく状況を説明。)
本研究で扱う環境において移動時間の遷移を長周期と短周期の2種類で定義したが、それらの周期的変化を実現する仕組みを説明する。
//絶対的な時刻を示すカウンターを持たせる
本研究では環境にカウンターを実装する。このカウンターは深層強化学習モデルのエージェントがノードを移動するたびに、定義した移動時間の数値の和を計算し、その数値分だけカウンターの数値を増加させる形態を持つ。このカウンターが閾値に到達した時、インデックス指定番号を変更することで周期的に移動時間の参照を変更し利用する。また、この閾値も任意の数値を設定することができ、それぞれの周期別に設定することで異なる周期パターンを導入することが可能となる。次の@fig:wf は一連の流れをワークフロー化した//示した
ものである。\ #linebreak()

#figure(
  image("../img/page3-2.png",height: 200pt),
  caption: [カウンターを利用した周期的変化のワークフロー]
)<wf>
#linebreak()
//ノードマップ環境が分からん。言葉を選ぶ。
//一般の言葉を造語にするから分からん。そのあたりは辞書引くなりなんなり。

//もう少し何か書く？
ただし、本研究においては周期的な環境を学習をさせる目的があるため、長周期が1周終わるごとにカウンターを0にリセットする仕組みを取る。

== 提案手法
本節では本研究の主眼である周期敵に変化する環境を学習する深層強化学習モデルの仕組みについて説明する。
=== 環境を考慮した深層強化学習モデル
//(入力次元やbackwardなどを示した図解を含めそれぞれのモデルの差について説明。カウンタ入力の方法に種類があるのを説明)
//(DQNについての説明。設定やパラメータは実験のセクションへ。)

これまでに説明した環境を利用するため本研究では深層強化学習のモデルの中でもDeep Q-network(DQN)@DBLP モデルを利用する。このモデルを利用する利点として、DQN自体が持つ経験再生による学習の安定性と、提案する環境において状態-行動空間を現在地-目的地として自然に対応させることができるという2点が挙げられる。

経験再生は過去に行った行動を保存し、一定数経過したのちにその中からランダムにサンプリングし学習を行うため、変化のある環境においてもサンプル間の偏りを低減させることが可能である。これにより、周期的に変化する移動時間を持つ提案環境においても一部の周期に学習データが偏らない安定した学習が可能になる。

また、状態は現在のノード、行動は次に移動すべきノードと対応させることができる。このような対応関係をもつ環境はQ学習を基にするDQNモデルの特性を用いることができると考えた。これらの理由から、本研究が提案する環境においてDQNの特性が適していると考え、利用するに至った。

DQNの探索戦略においては$epsilon$-greedy法を利用する。この方策は初期段階にランダム性の高い行動を多く選択し、学習が進むにつれ最適な行動を選択する割合を増加させるものである。

本研究におけるDQNモデル構造の略図を次の@fig:DQNex に示す。また、各種設定とハイパーパラメータを次の@tbl:Qpara に示す。\
#linebreak()
#figure(
  image("../img/page3-3.png",height: 200pt),
  caption:[Deep Q-networkモデル]
)<DQNex>
#linebreak()

#figure(
  caption:[Deep Q-Networkの各種設定、ハイパーパラメータ],
  table(
  columns: 2,
  table.header([種類],[設定条件]),
  [入力次元],[6or7(実験環境により変化)],
  [出力次元],[ノードの接続数により可変],
  [隠れ層],[1],
  [隠れ層ユニット数],[128],
  [各層の活性化関数],[ReLU],
  [割引率],[0.99],
  [学習率],[0.001],
  [バッチサイズ],[64],
  [経験メモリ数],[1000],
  [$epsilon$値],[1.0$>=epsilon>=0.01$],
  [$epsilon$減衰率],[0.995 or 0.999(実験環境により変化)],
  )
)<Qpara>
#linebreak()
各入力要素は現在ノード、スタートからの移動時間、カウンター情報、隣接するノード情報、長周期の移動時間、短周期の移動時間の6種類となる。

=== カウンター情報の入力方法
本研究において、マップ環境を制御するカウンター情報をDQNモデルの入力要素として扱うが、その値が学習途中に4桁以上の値を取ることが考えられる。この時、そのままDQNの入力情報として取り扱うと学習が発散することが考えられる。そのため、本研究では以下の3つの手法を扱い、比較することで学習の発散を防ぎつつそれぞれの特性を評価する。

- カウンターの正則化入力
カウンターの値を0～1の間で正規化することで、もとの情報を可能な限り保持したまま発散を防ぐ手段として利用する。本研究では長周期の環境が1周すればカウンターがリセットされるため、長周期の閾値を利用して0～1の範囲で正規化する。

- モジュロ演算
カウンター値を特定周期で折り返す事により、周期性を優先的に学習プロセスに入力する。この手法は確実に周期情報を与えるため、他の手法より周期変化を捉えやすいと考えた。本研究においては短周期の閾値とカウンター全体の計算結果を利用する。そのため、次の式で求めた値を利用するが、この値も閾値によって大きな数になることが考えられるため実験においてはこちらにも正則化を施す。

- インデックス指定値の入力
カウンターによって制御される移動時間指定用のインデックス指定値を入力する。時間情報の中でもスケールに依存しないため学習の安定性が向上すると考えらる。ただし、両周期の指定値を入力するために、入力次元は他手法と比べ1次元増加する。そのため学習時間の増大の可能性があるが、それぞれの移動時間がどの周期に依存するかが明確に利用できると考えた。

#pagebreak()