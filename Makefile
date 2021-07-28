# Название .ZIP-файла, содержащего собранный датапак.
name   = Armor Statues 2.9.2-RU-0.0.1

# Каталог, где будет создан ZIP-файл датапака.
outdir = build


.PHONY: build																																																																																\
	lint lint_json																																																																														\
	package																																																																																		\
	format format_json																																																																												\


build: lint compile_book package


lint: lint_json


lint_json:
	@find																																																																																			\
		-type f -iname "*.json"																																																																									\
	! -path "./reference/minecraft/*"	-a																																																																			\
	! -path "./translation/*"																																																																									\
		-print0																																																																																	\
	| while IFS= read -d "" file; do																																																																					\
		printf "%s" "$$(file="$${file#./data/}"; echo "$${file%.json}")"																																						 													 ;\
		err="$$(jq "" "$$file" 2>&1 >/dev/null)"																	 																																												 	 	 ;\
		if [ "$$?" -ne 0 ]; then																	 								 																																												  		\
			printf "%s\n" " - ОШИБКА"																								 																																												 	 	 ;\
			printf "%s: %s\n" "$$file" "$$err"																			 																																												 	 	 ;\
			exit 1																																	 																																												 	 	 ;\
		else																																			 																																															\
			printf "%s\n" " - OK"																										 																																												 	 	 ;\
		fi				 																																 																																												 	 	 ;\
	done												 																																												 	 	 																								 ;\


package:
	@mkdir -p "$(outdir)/datapacks"																												 																																									 ;\
	find																																																																																			\
		-type f																																																																																	\
	! \(																																																																																			\
			-path "./.git/*" -o																																																																										\
			-path "./reference/*" -o																																																																							\
			-path "./Makefile" -o																																																																									\
			-path "./.gitignore" -o																																																																								\
			-path "./.gitlab-ci.yml" -o																																																																						\
			-path "./data/armor_statues/loot_tables/book.txt"	-o																																																									\
			-path "./translation/*"	-o																																																																						\
			-path "./data/armor_statues/loot_tables/book_old.json" -o																																																							\
			-path "./data/armor_statues/loot_tables/book_nbt.json" -o																																																							\
			-path "./data/armor_statues/loot_tables/book/*"																																																								\
		\) 																																																																																			\
	| zip "$(outdir)/datapacks/$(name).zip" -@


format: format_json


format_json:
	@find																																																																																 			\
		-type f -iname "*.json"																																																																						 			\
	! -path "./reference/minecraft/*"																																																																		 			\
		-print0																																																																														 			\
	| while IFS= read -d "" file; do																																																																		 			\
		printf "%s" "$$(file="$${file#./data/}"; echo "$${file%.json}")"																																						 													 ;\
		err="$$(jq . "$$file" 2>&1 >"$$file~")"																		 																																												 	 	 ;\
		if [ "$$?" -ne 0 ]; then																	 								 																																												  		\
			printf "%s\n" " - ОШИБКА"																								 																																												 	 	 ;\
			printf "%s: %s\n" "$$file" "$$err"																			 																																												 	 	 ;\
			rm "$$file~"																														 																																												 	 	 ;\
			exit 1																																	 																																												 	 	 ;\
		else																																			 																																												 			\
			mv "$$file~" "$$file"																										 																																												 	 	 ;\
			printf "%s\n" " - OK"																										 																																												 	 	 ;\
		fi				 																																 																																												 	 	 ;\
	done


extract_book_nbt:
	@mkdir -p ./data/armor_statues/loot_tables/book																																																												   ;\
	jq -r ".pools[0].entries[0].functions[0].tag" ./data/armor_statues/loot_tables/book.json																																									\
	|python -c "import sys, hjson, json; json.dump(hjson.load(sys.stdin), sys.stdout)"																																												\
	|jq . > ./data/armor_statues/loot_tables/book_nbt.json														 																																											 ;\
	np=-1																																																																																		 ;\
	while IFS= read -r page; do																																																																								\
		np="$$((np + 1))"																																																																											 ;\
		printf "%s" "$$page" | jq . > "./data/armor_statues/loot_tables/book/page_$$np.json"																																									 ;\
	done <<< "$$(jq -r ".pages[]" ./data/armor_statues/loot_tables/book_nbt.json)"


compile_book:
	@nf="$$(find ./data/armor_statues/loot_tables/book -type f -printf . | wc -c)"																																										 			 ;\
	i=0																																																																																			 ;\
	cp ./data/armor_statues/loot_tables/book_nbt.json ./data/armor_statues/loot_tables/book_nbt.json~																																				 ;\
	while [ "$$i" -lt "$$nf" ]; do																																																																						\
		jq --arg page "$$(jq -c . "./data/armor_statues/loot_tables/book/page_$$i.json")" ".pages[$$i] |= \$$page"	./data/armor_statues/loot_tables/book_nbt.json~							\
		> "./data/armor_statues/loot_tables/book_nbt_$$i.json~"											 																																													 ;\
		mv "./data/armor_statues/loot_tables/book_nbt_$$i.json~" ./data/armor_statues/loot_tables/book_nbt.json~																															 ;\
		i="$$((i + 1))"																																																																												 ;\
	done																																																																																		 ;\
	mv ./data/armor_statues/loot_tables/book_nbt.json~ ./data/armor_statues/loot_tables/book_nbt.json																																				 ;\
	jq --arg nbt "$$(jq -c . ./data/armor_statues/loot_tables/book_nbt.json)" ".pools[0].entries[0].functions[0].tag = \$$nbt" ./data/armor_statues/loot_tables/book.json			\
	> ./data/armor_statues/loot_tables/book.json~																																																														 ;\
	mv ./data/armor_statues/loot_tables/book.json~ ./data/armor_statues/loot_tables/book.json
