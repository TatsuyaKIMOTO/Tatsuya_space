import SwiftUI

struct FlashcardView: View {
    let originalCards: [Card]

    @State private var activeCards: [Card] = []
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var cardRotation = 0.0

    init(cards: [Card]) {
        self.originalCards = cards
        _activeCards = State(initialValue: cards.shuffled())
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if !activeCards.isEmpty {
                    ProgressView(value: Double(currentIndex + 1), total: Double(activeCards.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.accentColor))
                        .padding(.horizontal)
                        .accessibilityLabel("進捗")
                        .accessibilityValue("\(currentIndex + 1) / \(activeCards.count)")

                    Text("カード \(currentIndex + 1) / \(activeCards.count)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityHidden(true)

                    Spacer()

                    ZStack {
                        if isFlipped {
                            CardFace(card: activeCards[currentIndex], isFront: false)
                                .accessibilityLabel("カードの裏面")
                                .accessibilityHint("タップでカードの表面に戻ります")
                        } else {
                            CardFace(card: activeCards[currentIndex], isFront: true)
                                .accessibilityLabel("カードの表面")
                                .accessibilityHint("タップでカードの裏面を表示します")
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 420)
                    .padding(.horizontal)
                    .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        flipCard()
                    }

                    Spacer()

                    HStack(spacing: 20) {
                        Button(action: showPreviousCard) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.largeTitle)
                        }
                        .disabled(currentIndex == 0)
                        .accessibilityLabel("前のカード")

                        Spacer()

                        Button(action: shuffleCards) {
                            Label("シャッフル", systemImage: "shuffle.circle.fill")
                                .font(.title)
                        }
                        .accessibilityHint("カードをシャッフルします")

                        Spacer()

                        Button(action: showNextCard) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.largeTitle)
                        }
                        .disabled(currentIndex == activeCards.count - 1)
                        .accessibilityLabel("次のカード")
                    }
                    .padding()
                } else {
                    Text("学習できるカードがありません。")
                }
            }
            .padding(.top)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let threshold: CGFloat = 50

                    if horizontalAmount < -threshold {
                        showNextCard()
                    } else if horizontalAmount > threshold {
                        showPreviousCard()
                    }
                }
        )
        .navigationTitle("学習")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if activeCards.isEmpty {
                activeCards = originalCards.shuffled()
            }
        }
    }

    func flipCard() {
        isFlipped.toggle()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            cardRotation = isFlipped ? 180 : 0
        }
    }

    func showNextCard() {
        if currentIndex < activeCards.count - 1 {
            currentIndex += 1
            resetCardState()
        }
    }

    func showPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            resetCardState()
        }
    }

    func shuffleCards() {
        withAnimation {
            activeCards.shuffle()
            currentIndex = 0
            resetCardState()
        }
    }

    func resetCardState() {
        if isFlipped {
            isFlipped = false
            cardRotation = 0
        }
    }
}

struct CardFace: View {
    let card: Card
    let isFront: Bool

    var body: some View {
        Group {
            if isFront {
                frontBody
            } else {
                backBody
            }
        }
        .frame(maxWidth: .infinity, minHeight: 420)
        .background(
            LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.8),
                                Color.blue.opacity(0.8),
                                Color.indigo.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 8)
                    .padding(.horizontal)
    }

    private var frontBody: some View {
        VStack {
            Spacer(minLength: 120)
            Text(card.frontText)
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.4)
                .padding(.horizontal)
            Spacer(minLength: 120)
        }
    }

    private var backBody: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !card.backMeaning.isEmpty {
                    InfoRow(label: "意味", content: card.backMeaning)
                }
                if !card.backEtymology.isEmpty {
                    Divider()
                    InfoRow(label: "語源", content: card.backEtymology)
                }
                if !card.backExample.isEmpty || !card.backExampleJP.isEmpty {
                    Divider()
                    if !card.backExample.isEmpty {
                        InfoRow(label: "例文", content: card.backExample)
                    }
                    if !card.backExampleJP.isEmpty {
                        InfoRow(label: "日本語訳", content: card.backExampleJP)
                    }
                }
            }
            .padding(36)
            .foregroundColor(.white)
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct InfoRow: View {
    let label: String
    let content: String

    var body: some View {
        if content.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                Text(content)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

extension Color {
    static let cardBackground = Color("elementBackground")
}
