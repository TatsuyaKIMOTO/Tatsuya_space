// CardListView.swift
import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var folder: Folder
    
    @State private var selectedCardToEdit: Card?
    @State private var showingAddCardView = false

    // カードを最新のものが上に来るようにソート
    private var cards: [Card] {
        (folder.cards ?? []).sorted(by: { $0.id.uuidString > $1.id.uuidString })
    }

    var body: some View {
        ZStack {
            // 定義したテーマカラーで背景を設定
            Color.appBackground.ignoresSafeArea()
            
            // カードがない場合の表示
            if cards.isEmpty {
                ContentUnavailableView("カードがありません", systemImage: "square.on.square.badge.person.crop", description: Text("右上の「+」ボタンから新しい単語カードを追加してください。"))
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        // 学習開始ボタン
                        NavigationLink(destination: FlashcardView(cards: cards)) {
                            HStack {
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                Text("学習を開始")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding()
                            .background(Color.accent) // テーマカラーのアクセント色
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.accent.opacity(0.4), radius: 8, y: 4)
                        }
                        .padding([.horizontal, .top])
                        
                        // カード一覧
                        ForEach(cards) { card in
                            Button(action: { selectedCardToEdit = card }) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(card.frontText)
                                        .font(.headline)
                                        .foregroundColor(.primary) // 自動でLight/Dark対応
                                    
                                    Text(card.backMeaning)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary) // 自動でLight/Dark対応
                                        .lineLimit(2)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.elementBackground) // テーマカラーの要素背景色
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .contextMenu { // 長押しメニュー
                                Button(action: { selectedCardToEdit = card }) {
                                    Label("編集", systemImage: "pencil")
                                }
                                Button(role: .destructive, action: { deleteCard(card: card) }) {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddCardView = true }) {
                    Label("カードを追加", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCardView) {
            // 新規追加モードでCardEditViewを開く
            CardEditView(folder: folder)
        }
        .sheet(item: $selectedCardToEdit) { card in
            // 編集モードでCardEditViewを開く
            CardEditView(cardToEdit: card)
        }
    }

    // カードを削除する関数
    private func deleteCard(card: Card) {
        withAnimation {
            modelContext.delete(card)
        }
    }
}
