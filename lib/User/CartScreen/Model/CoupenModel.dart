class Coupon {
  final String id;
  final String couponName;
  final String valueType;
  final String value;
  final String minimumSpent;
  final int usedByCount;
  final int usageLimitPerPerson;
  final DateTime validFrom;
  final DateTime validTill;
  final DateTime createdAt;
  final DateTime updatedAt;

  Coupon({
    required this.id,
    required this.couponName,
    required this.valueType,
    required this.value,
    required this.minimumSpent,
    required this.usedByCount,
    required this.usageLimitPerPerson,
    required this.validFrom,
    required this.validTill,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      couponName: json['couponName'],
      valueType: json['ValueType'],
      value: json['Value'],
      minimumSpent: json['minimumSpent'],
      usedByCount: json['usedByCount'] ?? 0,
      usageLimitPerPerson: json['usageLimitPerPerson'] ?? 0,
      validFrom: DateTime.parse(json['validFrom']),
      validTill: DateTime.parse(json['ValidTill']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CouponResponse {
  final List<Coupon> coupons;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  CouponResponse({
    required this.coupons,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = data['meta'];

    return CouponResponse(
      coupons: List<Coupon>.from(data['data'].map((x) => Coupon.fromJson(x))),
      page: meta['page'],
      limit: meta['limit'],
      total: meta['total'],
      totalPages: meta['totalPages'],
      hasNext: meta['hasNext'],
      hasPrev: meta['hasPrev'],
    );
  }
}
