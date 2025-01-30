// フォントの設定
// google Font(https://fonts.google.com/)から以下のフォントをダウンロードし、各OSのシステムにインストールしてください。
// - Noto Sans JP
// - Noto Serif JP

#import "template.typ": titlePage,mainPage
// chapterに対応した図番号をつけるためのライブラリ
#import "@preview/i-figured:0.2.4"
// set up heading numbering
#set heading(numbering: "1.")
// this resets all figure counters at every level 1 heading.
// custom figure kinds must be added here.
#show heading: i-figured.reset-counters
// this show rule is the main logic, custom prefixes for custom figure kinds
// can optionally be added here.
#show figure: i-figured.show-figure
// a similar function exists for math equations
//#show math.equation: i-figured.show-equation

//↓ここから書き換える
#show: doc => titlePage(
  year: "2024",
  title: [周期的に変化する環境に対応可能な\ 深層強化学習に関する研究], 
  university: "大阪工業大学",
  department: "ロボティクス＆デザイン工学部",
  faculty: "システムデザイン工学科",
  lab: "知能ロボティクス研究室",
  name: "小村 晟輝",
  supervisor: "小林 裕之 教授",
  hankoName: ("小","林"),
  doc
)

#show: doc => mainPage(doc)

#include "chapter1/chapter1.typ"

#include "chapter2/chapter2.typ"

#include "chapter3/chapter3.typ"

#include "chapter4/chapter4.typ"

#include "chapter5/chapter5.typ"

#include "chapter6/chapter6.typ"

// 謝辞はchapter99/chapter99.typに書く
#pagebreak()
#heading(numbering: none, [参考文献])
#set text(lang: "en")
#bibliography(
	"reference.bib",
  title: none
)
#pagebreak()
#set page(numbering: none)
#include "chapter99/chapter99.typ"