// FlashcardView.swift
import SwiftUI

struct FlashcardView: View {
    let originalCards: [Card]
    @State private var activeCards: [Card] = []
    
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
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
    
    func showNextCard() {
        if currentIndex < activeCards.count - 1 {
            isFlipped = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                currentIndex += 1
            }
        }
    }

    func showPreviousCard() {
        if currentIndex > 0 {
            isFlipped = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                currentIndex -= 1
            }
        }
    }
    
    func shuffleCards() {
        isFlipped = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation {
                activeCards.shuffle()
                currentIndex = 0
            }
        }
    }
}


// MARK: - Subviews

private struct LearningCardFace: View {
    let card: Card
    let isFront: Bool
    
    var body: some View {
        ZStack {
            // ★★★ CardListViewと共通の背景を使用します ★★★
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

// ★★★ ここが、この問題の唯一の、そして完全な解決策です ★★★
// CardListView.swiftで定義したCardBackgroundを、このファイルにも追加します。
// これにより、Cannot find 'CardBackground' in scopeエラーが解消されます。
struct CardBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
