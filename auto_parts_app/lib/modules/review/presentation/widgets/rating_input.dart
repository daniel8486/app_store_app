import 'package:flutter/material.dart';

class RatingInput extends StatefulWidget {
  final Function(double) onRatingChanged;
  final bool showComment;
  final Function(String)? onCommentChanged;
  final String? initialComment;

  const RatingInput({
    Key? key,
    required this.onRatingChanged,
    this.showComment = true,
    this.onCommentChanged,
    this.initialComment,
  }) : super(key: key);

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  double _currentRating = 0;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(text: widget.initialComment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rating stars
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                'Qual sua avaliação?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentRating = rating.toDouble();
                        widget.onRatingChanged(_currentRating);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        _currentRating >= rating
                            ? Icons.star
                            : Icons.star_outline,
                        size: 40,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 8),
              if (_currentRating > 0)
                Text(
                  _getRatingLabel(_currentRating),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),

        // Comment field
        if (widget.showComment) ...[
          SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 4,
            minLines: 3,
            onChanged: widget.onCommentChanged,
            decoration: InputDecoration(
              hintText: 'Compartilhe seus comentários sobre este produto...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ],
      ],
    );
  }

  String _getRatingLabel(double rating) {
    switch (rating.toInt()) {
      case 1:
        return 'Péssimo';
      case 2:
        return 'Ruim';
      case 3:
        return 'Normal';
      case 4:
        return 'Bom';
      case 5:
        return 'Excelente';
      default:
        return '';
    }
  }
}
