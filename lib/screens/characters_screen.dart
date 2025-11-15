import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rika_and_morti_characters/widgets/character_card.dart';
import 'package:rika_and_morti_characters/providers/characyter_provider.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().loadInitialCharacters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterProvider>().loadMoreCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.characters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError && provider.characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load characters',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please check your internet connection',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadInitialCharacters(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshCharacters(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.characters.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.characters.length) {
                  return provider.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox(height: 16);
                }

                final character = provider.characters[index];
                return CharacterCard(
                  character: character,
                  onFavoritePressed: () => provider.toggleFavorite(character),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
