import '../../domain/entities/discussion_board_models.dart';

List<DiscussionThread> buildDiscussionBoardMockSeed() {
  const goldBadge = DiscussionAuthorBadge(
    label: 'Gold投資家',
    backgroundColorValue: 0xFFEDE9FE,
    foregroundColorValue: 0xFF8B5CF6,
  );
  const investorBadge = DiscussionAuthorBadge(
    label: '投資家',
    backgroundColorValue: 0xFFD1FAE5,
    foregroundColorValue: 0xFF10B981,
  );
  const newInvestorBadge = DiscussionAuthorBadge(
    label: '新人投資家',
    backgroundColorValue: 0xFFDBEAFE,
    foregroundColorValue: 0xFF2563EB,
  );

  const sato = DiscussionAuthor(
    id: 'u_sato',
    displayName: '佐藤**',
    accountHandle: 'sat***@',
    avatarText: '佐',
    avatarGradientColorValues: <int>[0xFFEC4899, 0xFFF472B6],
    badge: goldBadge,
  );
  const takahashi = DiscussionAuthor(
    id: 'u_takahashi',
    displayName: '高橋**',
    accountHandle: 'tak***@',
    avatarText: '高',
    avatarGradientColorValues: <int>[0xFFF59E0B, 0xFFFBBF24],
    badge: investorBadge,
  );
  const watanabe = DiscussionAuthor(
    id: 'u_watanabe',
    displayName: '渡辺**',
    accountHandle: 'wat***@',
    avatarText: '渡',
    avatarGradientColorValues: <int>[0xFF6366F1, 0xFF818CF8],
    badge: goldBadge,
  );
  const nakamura = DiscussionAuthor(
    id: 'u_nakamura',
    displayName: '中村**',
    accountHandle: 'nak***@',
    avatarText: '中',
    avatarGradientColorValues: <int>[0xFF10B981, 0xFF34D399],
    badge: newInvestorBadge,
  );
  const yamada = DiscussionAuthor(
    id: 'u_yamada',
    displayName: 'yam***',
    accountHandle: '',
    avatarText: '山',
    avatarGradientColorValues: <int>[0xFF2563EB, 0xFF60A5FA],
    badge: investorBadge,
  );
  const suzuki = DiscussionAuthor(
    id: 'u_suzuki',
    displayName: 'suz***',
    accountHandle: '',
    avatarText: '鈴',
    avatarGradientColorValues: <int>[0xFF10B981, 0xFF34D399],
    badge: investorBadge,
  );
  const tak = DiscussionAuthor(
    id: 'u_tak',
    displayName: 'tak***',
    accountHandle: '',
    avatarText: '高',
    avatarGradientColorValues: <int>[0xFFF59E0B, 0xFFFBBF24],
    badge: investorBadge,
  );

  return <DiscussionThread>[
    const DiscussionThread(
      id: 'thread_1',
      author: sato,
      timeLabel: '2時間前',
      body: '赤坂のレジデンス案件、立地が最高ですね。港区の賃貸需要を考えると稼働率は安定しそう。利回り8.5%は魅力的です。',
      createdAtIso: '2026-03-05T10:00:00Z',
      fundReferenceLabel: 'プレミアムレジデンス赤坂 →',
      fundReferenceId: 'mock-fund-1',
      commentCount: 3,
      replies: <DiscussionReply>[
        DiscussionReply(
          id: 'reply_1_1',
          author: yamada,
          timeLabel: '1時間前',
          body: '同感です！RC造15階建で2019年竣工なので築浅。管理状態も良さそう。',
          createdAtIso: '2026-03-05T11:00:00Z',
        ),
        DiscussionReply(
          id: 'reply_1_2',
          author: suzuki,
          timeLabel: '45分前',
          body: '劣後出資30%は安心感ありますね。私も申し込む予定です！',
          createdAtIso: '2026-03-05T11:15:00Z',
        ),
        DiscussionReply(
          id: 'reply_1_3',
          author: tak,
          timeLabel: '30分前',
          body: '確かに！ただ抽選倍率も高そうですね。人気案件は競争率が厳しい…',
          createdAtIso: '2026-03-05T11:30:00Z',
          quote: DiscussionQuote(
            sourceText: '佐藤** の投稿を引用：',
            body: '利回り8.5%は魅力的です。',
          ),
        ),
      ],
    ),
    const DiscussionThread(
      id: 'thread_2',
      author: takahashi,
      timeLabel: '5時間前',
      body:
          '先月の分配金が入金されました！オフィスビル案件、予定通りの利回りで安定運用中。不動産クラファン始めて半年ですが、銀行預金とは比べものにならないリターンです。',
      createdAtIso: '2026-03-05T07:00:00Z',
      commentCount: 5,
      replies: <DiscussionReply>[
        DiscussionReply(
          id: 'reply_2_1',
          author: DiscussionAuthor(
            id: 'u_wat',
            displayName: 'wat***',
            accountHandle: '',
            avatarText: '渡',
            avatarGradientColorValues: <int>[0xFF6366F1, 0xFF818CF8],
            badge: investorBadge,
          ),
          timeLabel: '4時間前',
          body: 'おめでとうございます！分配金が安定して入ると嬉しいですよね。',
          createdAtIso: '2026-03-05T08:00:00Z',
        ),
      ],
    ),
    const DiscussionThread(
      id: 'thread_3',
      author: watanabe,
      timeLabel: '昨日',
      body:
          '京都の町家ホテル案件が気になります。インバウンド需要回復中、東山区の立地は最高。利回り10%は高めですが、観光需要リスクもありますね。皆さんどう思いますか？',
      createdAtIso: '2026-03-04T09:00:00Z',
      fundReferenceLabel: '町家リノベーションホテル →',
      fundReferenceId: 'mock-fund-2',
      commentCount: 2,
      replies: <DiscussionReply>[
        DiscussionReply(
          id: 'reply_3_1',
          author: DiscussionAuthor(
            id: 'u_sat',
            displayName: 'sat***',
            accountHandle: '',
            avatarText: '佐',
            avatarGradientColorValues: <int>[0xFFEC4899, 0xFFF472B6],
            badge: investorBadge,
          ),
          timeLabel: '20時間前',
          body: 'インバウンドはコロナ前を超えてるのでポジティブに見てます。ただ24ヶ月は長いですね。',
          createdAtIso: '2026-03-04T13:00:00Z',
          quote: DiscussionQuote(
            sourceText: '渡辺** の投稿を引用：',
            body: '観光需要リスクもありますね。',
          ),
        ),
      ],
    ),
    const DiscussionThread(
      id: 'thread_4',
      author: nakamura,
      timeLabel: '2日前',
      body:
          '不動産クラファン初心者です。優先劣後構造の仕組みを理解して安心しました。まずは10万円から。先輩方、アドバイスお願いします。',
      createdAtIso: '2026-03-03T10:00:00Z',
      commentCount: 12,
      replies: <DiscussionReply>[
        DiscussionReply(
          id: 'reply_4_1',
          author: DiscussionAuthor(
            id: 'u_wat_2',
            displayName: 'wat***',
            accountHandle: '',
            avatarText: '渡',
            avatarGradientColorValues: <int>[0xFF6366F1, 0xFF818CF8],
            badge: investorBadge,
          ),
          timeLabel: '2日前',
          body: 'ようこそ！最初は劣後出資比率が高い案件を選ぶのがおすすめです。30%以上あると安心感が違います。',
          createdAtIso: '2026-03-03T12:00:00Z',
        ),
        DiscussionReply(
          id: 'reply_4_2',
          author: DiscussionAuthor(
            id: 'u_sat_2',
            displayName: 'sat***',
            accountHandle: '',
            avatarText: '佐',
            avatarGradientColorValues: <int>[0xFFEC4899, 0xFFF472B6],
            badge: investorBadge,
          ),
          timeLabel: '2日前',
          body: '複数案件に分散投資するのも大事ですよ。1案件に集中するよりリスク分散できます！',
          createdAtIso: '2026-03-03T13:00:00Z',
        ),
      ],
    ),
  ];
}
