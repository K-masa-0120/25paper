#import "template.typ": titlePage,mainPage
// chapterに対応した図番号をつけるためのライブラリ
#import "@preview/i-figured:0.2.4"
#show heading: i-figured.reset-counters
#show figure: i-figured.show-figure

//↓ここから書き換える
#show: doc => titlePage(
  year: "2024",
  title: [周期的に変化する環境に対応可能な深層強化学習に関する研究], 
  university: "大阪工業大学",
  department: "ロボティクス＆デザイン工学部",
  faculty: "システムデザイン工学科",
  lab: "知能ロボティクス研究室",
  name: "小村 晟輝 ",
  supervisor: "小林 裕之 教授",
  hankoName: ("先","生"),
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