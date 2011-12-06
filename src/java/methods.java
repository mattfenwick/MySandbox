	static <T> List<T> sortEntries(Map<Integer, T> map) {
        // convert the entry-set into a list
		List<Entry<Integer, T>> entries = new ArrayList<Entry<Integer,T>>();
		for(Entry<Integer, T> e : map.entrySet()) {
			entries.add(e);
		}
		
		//sort entries by key
		Collections.sort(entries, new Comparator<Entry<Integer, T>>() {

			@Override
			public int compare(Entry<Integer, T> o1,
					Entry<Integer, T> o2) {
				return o1.getKey().compareTo(o2.getKey());
			}
		});
		
		// ditch the keys -- keep only the values
		List<T> out = new ArrayList<T>();
		for(Entry<Integer, T> e : entries) {
			out.add(e.getValue());
		}
		return out;
	}