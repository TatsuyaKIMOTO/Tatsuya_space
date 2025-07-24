import SwiftUI

struct FlashcardView: View {
    let originalCards: [Card]
    @State private var activeCards: [Card] = []
    
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
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
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translationX = gesture.translation.width
                                
                                if (currentIndex == 0 && translationX > 0) || (currentIndex == activeCards.count - 1 && translationX < 0) {
                                    offset = CGSize(width: translationX / 5.0, height: 0)
                                } else {
                                    offset = gesture.translation
                                }
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -100 {
                                    showNextCard()
                                } else if gesture.translation.width > 100 {
                                    showPreviousCard()
                                } else {
                                    withAnimation(.spring) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
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
            withAnimation(.spring) {
                offset = .zero
            }
            return
        }
        
        withAnimation(.spring) {
            offset = CGSize(width: -500, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFlipped = false
            currentIndex += 1
            offset = .zero
        }
    }

    func showPreviousCard() {
        guard currentIndex > 0 else {
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
            offset = .zero
        }
    }
    
    func shuffleCards() {
        isFlipped = false
        currentIndex = 0
        withAnimation {
            activeCards.shuffle()
            offset = .zero
        }
    }
}


// MARK: - Subviews

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
            
            // ★★★★★★★★★★★★★★★★★★★★ 修正点 ★★★★★★★★★★★★★★★★★★★★
            // カード裏面のコンテンツを表示するTextビューです。
            // フォントサイズを60から28に大幅に縮小し、文字の太さを.boldから
            // .semiboldに少し細くすることで、読みやすさを向上させました。
            // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
            Text(content)
                .font(.system(size: 28, weight: .semibold, design: .rounded)) // ← サイズと太さを変更
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
