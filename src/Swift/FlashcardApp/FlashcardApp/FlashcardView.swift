// FlashcardView.swift
import SwiftUI

struct FlashcardView: View {
    // 受け取った元のカード配列
    let originalCards: [Card]
    
    // 現在表示しているシャッフル済みのカード配列
    @State private var activeCards: [Card] = []
    
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var cardRotation = 0.0
    
    // コンストラクタをカスタムして、受け取ったcardsをシャッフルしてactiveCardsにセット
    init(cards: [Card]) {
        self.originalCards = cards
        // _activeCardsの初期値を設定する
        _activeCards = State(initialValue: cards.shuffled())
    }

    var body: some View {
        VStack(spacing: 20) {
            if !activeCards.isEmpty {
                // プログレスバー
                ProgressView(value: Double(currentIndex + 1), total: Double(activeCards.count))
                    .padding(.horizontal)
                
                Text("カード \(currentIndex + 1) / \(activeCards.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                // フラッシュカード本体
                ZStack {
                    // isFlippedがtrueなら裏面、falseなら表面を表示
                    if isFlipped {
                        CardFace(card: activeCards[currentIndex], isFront: false)
                    } else {
                        CardFace(card: activeCards[currentIndex], isFront: true)
                    }
                }
                .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    flipCard()
                }
                
                Spacer()

                // ナビゲーションボタン
                HStack(spacing: 20) {
                    // 戻るボタン
                    Button(action: showPreviousCard) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                    }
                    .disabled(currentIndex == 0)

                    Spacer()
                    
                    // シャッフルボタン
                    Button(action: shuffleCards) {
                        Label("シャッフル", systemImage: "shuffle.circle.fill")
                            .font(.title)
                    }
                    
                    Spacer()

                    // 次へボタン
                    Button(action: showNextCard) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.largeTitle)
                    }
                    .disabled(currentIndex == activeCards.count - 1)
                }
                .padding()
            } else {
                Text("学習できるカードがありません。")
            }
        }
        .navigationTitle("学習")
        .navigationBarTitleDisplayMode(.inline)
        // ビューが表示されたときに呼ばれる
        .onAppear {
            // もし何らかの理由でactiveCardsが空なら再シャッフル
            if activeCards.isEmpty {
                activeCards = originalCards.shuffled()
            }
        }
    }
    
    // カードをめくるアニメーション
    func flipCard() {
        isFlipped.toggle()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            cardRotation += 180
        }
    }

    // 次のカードへ
    func showNextCard() {
        if currentIndex < activeCards.count - 1 {
            currentIndex += 1
            resetCardState()
        }
    }

    // 前のカードへ
    func showPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            resetCardState()
        }
    }
    
    // カードをシャッフルする
    func shuffleCards() {
        withAnimation {
            activeCards.shuffle()
            currentIndex = 0
            resetCardState()
        }
    }
    
    // カードの状態をリセット（表面に戻す）
    func resetCardState() {
        if isFlipped {
            isFlipped = false
            cardRotation += 180 // アニメーションなしで角度を戻す
        }
    }
}

// ↓↓↓ ここから下が重要です！このコードがファイルに含まれているか確認してください。 ↓↓↓

// FlashcardView.swift
// FlashcardViewのstruct自体は変更なし。
// 下部にあるCardFaceとInfoRowを以下のように書き換えます。

// カードの表面・裏面を定義するビュー
struct CardFace: View {
    let card: Card
    let isFront: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isFront {
                    Spacer(minLength: 100)
                    Text(card.frontText)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .minimumScaleFactor(0.5)
                    Spacer(minLength: 100)
                } else {
                    // 裏面のレイアウト
                    VStack(alignment: .leading, spacing: 18) {
                        InfoRow(label: "意味", content: card.backMeaning)
                        
                        if !card.backEtymology.isEmpty {
                            Divider()
                            InfoRow(label: "語源", content: card.backEtymology)
                        }
                        
                        if !card.backExample.isEmpty || !card.backExampleJP.isEmpty {
                            Divider()
                            InfoRow(label: "例文", content: card.backExample)
                            InfoRow(label: "日本語訳", content: card.backExampleJP)
                        }
                    }
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .padding(30)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
        // ★★★ ダークモード対応の核心部分 ★★★
        .background(Color.elementBackground)
        .cornerRadius(20)
        // 影をよりソフトに
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .overlay(
            // 表面であることを示すインジケーター
            VStack {
                if isFront {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.2.circlepath")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                Spacer()
            }
        )
        .padding(.horizontal)
    }
}

// 裏面の情報表示用のヘルパービュー
struct InfoRow: View {
    let label: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary) // .secondaryで自動的に色が調整される
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary) // .primaryで自動的に色が調整される
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
