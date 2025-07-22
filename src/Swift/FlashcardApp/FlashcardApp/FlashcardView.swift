// FlashcardView.swift
import SwiftUI

struct FlashcardView: View {
    let originalCards: [Card]
    @State private var activeCards: [Card] = []
    
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
    // スワイプ操作の状態を管理するための変数
    @State private var offset: CGSize = .zero
    
    init(cards: [Card]) {
        self.originalCards = cards
        _activeCards = State(initialValue: cards.shuffled())
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if !activeCards.isEmpty {
                    ProgressView(value: Double(currentIndex + 1), total: Double(activeCards.count))
                        .padding(.horizontal)
                    
                    Text("カード \(currentIndex + 1) / \(activeCards.count)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    ZStack {
                        LearningCardFace(card: activeCards[currentIndex], isFront: !isFlipped)
                    }
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .offset(x: offset.width)
                    .rotationEffect(.degrees(offset.width / 20.0))
                    // ★★★ ここからが、この問題の唯一の、そして完全な解決策です ★★★
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translationX = gesture.translation.width
                                
                                // 【抵抗】進めない方向へのスワイプには「抵抗」を適用
                                if (currentIndex == 0 && translationX > 0) || (currentIndex == activeCards.count - 1 && translationX < 0) {
                                    // 指の動きの5分の1しか動かないようにして、抵抗感を表現
                                    offset = CGSize(width: translationX / 5.0, height: 0)
                                } else {
                                    // 通常のスワイプ
                                    offset = gesture.translation
                                }
                            }
                            .onEnded { gesture in
                                // スワイプが一定距離を超えた場合のみ、カードを遷移
                                if gesture.translation.width < -100 {
                                    showNextCard()
                                } else if gesture.translation.width > 100 {
                                    showPreviousCard()
                                } else {
                                    // 【復元】距離が不十分な場合は、バネのように元の位置に戻す
                                    withAnimation(.spring) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                    // ★★★ ここまで ★★★
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            isFlipped.toggle()
                        }
                    }
                    
                    Spacer()

                    HStack(spacing: 20) {
                        Button(action: showPreviousCard) { Image(systemName: "arrow.left.circle.fill").font(.largeTitle) }
                        .disabled(currentIndex == 0)

                        Spacer()
                        
                        Button(action: shuffleCards) { Label("シャッフル", systemImage: "shuffle.circle.fill").font(.title) }
                        
                        Spacer()

                        Button(action: showNextCard) { Image(systemName: "arrow.right.circle.fill").font(.largeTitle) }
                        .disabled(currentIndex == activeCards.count - 1)
                    }
                    .padding()
                } else {
                    ContentUnavailableView("学習できるカードがありません", systemImage: "books.vertical.fill")
                }
            }
        }
        .navigationTitle("学習")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if activeCards.isEmpty {
                activeCards = originalCards.shuffled()
            }
        }
    }
    
    // MARK: - Functions
    
    func showNextCard() {
        guard currentIndex < activeCards.count - 1 else {
            // これ以上進めない場合は、カードを元の位置に優しく戻す
            withAnimation(.spring) {
                offset = .zero
            }
            return
        }
        
        withAnimation(.spring) {
            // カードを画面外へ飛ばすアニメーション
            offset = CGSize(width: -500, height: 0)
        }
        
        // アニメーションの後に状態をリセットし、次のカードへ
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFlipped = false
            currentIndex += 1
            offset = .zero // アニメーションなしでオフセットをリセット
        }
    }

    func showPreviousCard() {
        guard currentIndex > 0 else {
            // これ以上戻れない場合は、カードを元の位置に優しく戻す
            withAnimation(.spring) {
                offset = .zero
            }
            return
        }
        
        withAnimation(.spring) {
            offset = CGSize(width: 500, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFlipped = false
            currentIndex -= 1
            offset = .zero // アニメーションなしでオフセットをリセット
        }
    }
    
    func shuffleCards() {
        isFlipped = false
        // currentIndexをリセットしてからシャッフルする
        currentIndex = 0
        withAnimation {
            activeCards.shuffle()
            offset = .zero
        }
    }
}


// MARK: - Subviews (変更なし)

private struct LearningCardFace: View {
    let card: Card
    let isFront: Bool
    
    var body: some View {
        ZStack {
            CardBackground()
            ScrollView {
                VStack {
                    if isFront {
                        frontFaceContent
                    } else {
                        backFaceContent
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .padding(30)
                .frame(maxWidth: .infinity, minHeight: 400, alignment: .center)
            }
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)
        .padding(.horizontal)
    }
    
    private var frontFaceContent: some View {
        VStack {
            Spacer(minLength: 150)
            Text(card.frontText)
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
            Spacer(minLength: 150)
        }
    }
    
    private var backFaceContent: some View {
        VStack(alignment: .leading, spacing: 30) {
            LearningInfoRow(label: "意味", content: card.backMeaning)
            
            if !card.backEtymology.isEmpty {
                LearningInfoRow(label: "語源", content: card.backEtymology)
            }
            if !card.backExample.isEmpty {
                LearningInfoRow(label: "例文", content: card.backExample)
            }
            if !card.backExampleJP.isEmpty {
                LearningInfoRow(label: "日本語訳", content: card.backExampleJP)
            }
        }
    }
}

private struct LearningInfoRow: View {
    let label: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.8))
            
            Text(content)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CardBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
